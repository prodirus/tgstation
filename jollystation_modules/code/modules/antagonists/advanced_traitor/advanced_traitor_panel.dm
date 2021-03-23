/// The advanced traitor goal panel used to set and finalized goals.
/datum/adv_traitor_panel
	var/mob/viewer
	var/datum/antagonist/traitor/traitor_plus/owner_datum
	var/datum/tgui/open_ui

/datum/adv_traitor_panel/New(mob/user, datum/antagonist/traitor/traitor_plus/owner_datum)
	if(istype(user))
		viewer = user
	else
		var/client/user_client = user
		viewer = user_client.mob

	src.owner_datum = owner_datum

/datum/adv_traitor_panel/ui_close()
	open_ui = null
	owner_datum.cleanup_advanced_traitor_panel(viewer)
	qdel(src)

/datum/adv_traitor_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_AdvancedTraitorPanel")
		ui.open()
		open_ui = ui

/datum/adv_traitor_panel/ui_state(mob/user)
	if(viewer != owner_datum.owner.current)
		to_chat(user, "You are viewing [owner_datum.owner.current]'s advanced traitor panel as an admin.")
		message_admins("[ADMIN_LOOKUPFLW(user)] is viewing [ADMIN_LOOKUPFLW(owner_datum.owner.current)]'s advanced traitor panel as an admin.")
		return GLOB.admin_state
	else
		return GLOB.always_state

/datum/adv_traitor_panel/ui_data(mob/user)
	var/list/data = list()

	data["traitor_type"] = owner_datum.traitor_kind
	data["name"] = owner_datum.name
	data["employer"] = owner_datum.employer
	data["backstory"] = owner_datum.backstory
	data["goals_finalized"] = owner_datum.should_equip
	data["finalized_tc"] = owner_datum.get_traitor_points_from_goals()

	var/goal_num = 1
	for(var/datum/advanced_antag_goal/found_goal in owner_datum.our_goals)
		var/list/goal_data = list(
			id = goal_num,
			ref = REF(found_goal),
			goal = found_goal.goal,
			intensity = found_goal.intensity,
			notes = found_goal.notes,
			check_all_objectives = found_goal.check_all_objectives,
			always_succeed = found_goal.always_succeed,
			objective_data = list(),
			)
		if(LAZYLEN(found_goal.similar_objectives))
			var/obj_num = 1
			for(var/datum/objective/found_objective in found_goal.similar_objectives)
				var/list/found_objective_data = list(
					id = obj_num,
					ref = REF(found_objective),
					text = found_objective.explanation_text,
				)
				goal_data["objective_data"] += list(found_objective_data)
				obj_num++
		data["goals"] += list(goal_data)
		goal_num++

	return data

/datum/adv_traitor_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!owner_datum)
		CRASH("Advanced traitor panel being operated with no advanced traitor datum.")

	var/datum/advanced_antag_goal/edited_goal

	if(params["goal_ref"])
		edited_goal = locate(params["goal_ref"]) in owner_datum.our_goals
		if(!edited_goal)
			CRASH("Advanced_traitor_panel passed a reference parameter to a goal that it could not locate!")

	switch(action)
		/// Background stuff
		if("set_name")
			owner_datum.name = strip_html_simple(params["name"], MAX_NAME_LEN)
			. = TRUE
		if("set_employer")
			owner_datum.employer = strip_html_simple(params["employer"], MAX_NAME_LEN)
			. = TRUE
		if("set_backstory")
			owner_datum.backstory = strip_html_simple(params["backstory"], MAX_MESSAGE_LEN)
			. = TRUE

		/// Goal Stuff
		if("add_advanced_goal")
			. = TRUE
			if(LAZYLEN(owner_datum.our_goals) > TRAITOR_PLUS_MAX_GOALS)
				to_chat(usr, "Maximum amount of goals reached.")
				return

			owner_datum.add_advanced_goal()

		if("finalize_goals")
			. = TRUE
			if(owner_datum.should_equip)
				return

			owner_datum.should_equip = TRUE
			owner_datum.finalize_traitor()
			owner_datum.modify_traitor_points()
			owner_datum.log_goals_on_finalize()

		if("remove_advanced_goal")
			owner_datum.remove_advanced_goal(edited_goal)
			. = TRUE

		if("set_goal_text")
			edited_goal.set_goal_text(strip_html_simple(params["newgoal"], TRAITOR_PLUS_MAX_GOAL_LENGTH))
			. = TRUE

		if("set_goal_intensity")
			edited_goal.set_intensity(clamp(params["newlevel"], 1, 5))
			. = TRUE

		if("set_note_text")
			edited_goal.notes = strip_html_simple(params["newtext"], TRAITOR_PLUS_MAX_NOTE_LENGTH)
			. = TRUE

		if("add_similar_objective")
			. = TRUE
			if(LAZYLEN(edited_goal.similar_objectives) > TRAITOR_PLUS_MAX_SIMILAR_OBJECTIVES)
				to_chat(usr, "Maximum amount of similar objectives reached for this goal.")
				return

			if(!GLOB.admin_objective_list)
				generate_admin_objective_list()
			var/list/objectives_to_choose = GLOB.admin_objective_list.Copy() - owner_datum.blacklisted_similar_objectives
			if(owner_datum.traitor_kind == TRAITOR_AI)
				objectives_to_choose -= owner_datum.blacklisted_ai_objectives
				objectives_to_choose += owner_datum.ai_objectives

			var/list/edited_similar_objectives = LAZYCOPY(edited_goal.similar_objectives)
			var/datum/objective/new_objective_type = input("Add an objective:", "Objective type", null) as null|anything in objectives_to_choose
			new_objective_type = objectives_to_choose[new_objective_type]
			if(new_objective_type)
				var/datum/objective/added_objective = new new_objective_type
				added_objective.owner = owner_datum.owner
				edited_similar_objectives.Add(added_objective)
				added_objective.admin_edit(usr)
			else
				return

			edited_goal.similar_objectives = edited_similar_objectives

		if("remove_similar_objective")
			. = TRUE
			var/list/edited_similar_objectives = edited_goal.similar_objectives.Copy()
			var/datum/objective/removed_objective = locate(params["objective_ref"]) in edited_similar_objectives
			if(!removed_objective)
				CRASH("Advanced_traitor_panel passed a reference to an objective belonging to a goal that could not be located!")

			if(edited_similar_objectives.Remove(removed_objective))
				qdel(removed_objective)
				edited_goal.similar_objectives = edited_similar_objectives

		if("clear_sim_objectives")
			QDEL_LIST(edited_goal.similar_objectives)
			. = TRUE

		if("toggle_check_all_objectives")
			edited_goal.check_all_objectives = !edited_goal.check_all_objectives
			. = TRUE

		if("toggle_always_succeed")
			edited_goal.always_succeed = !edited_goal.always_succeed
			. = TRUE
