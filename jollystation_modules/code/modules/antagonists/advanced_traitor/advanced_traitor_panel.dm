/// The advanced traitor goal panel used to set and finalized goals.
/// Separated out the HTML data from the main traitor_plus file for cleanliness.
/*
/datum/antagonist/traitor/traitor_plus/proc/build_advanced_panel_html()
	var/dat = ""
	dat += "<div align='center'><a href='?src=[REF(src)];set_name=1'>Set Antagonist Name:</a> [name][FOURSPACES][FOURSPACES]"
	dat += "<a href='?src=[REF(src)];set_employer=1'>Set Antagonist Employer:</a> [employer]</div>"
	dat += "<div width=40%><a href='?src=[REF(src)];set_backstory=1'>Set Backstory:</a> [backstory]</div><div width=60%> </div>"

	dat += "<hr>"

	var/intensity_color = "#f00"
	if(LAZYLEN(our_goals))
		var/count = 1
		for(var/datum/advanced_antag_goal/all_goals in our_goals)
			if(count > TRAITOR_PLUS_MAX_GOALS)
				break

			switch(all_goals.intensity)
				if(1)
					intensity_color = "#7bff00"
				if(2)
					intensity_color = "#fbff00"
				if(3)
					intensity_color = "#ffa600"
				if(4)
					intensity_color = "#ff8800"
				if(5)
					intensity_color = "#f00"

			dat += "<table width=100%>"
			dat += "<b> Goal #[count]: </b>"
			dat += "<tr>"
			dat += "<td width='30%'><center><a href='?src=[REF(src)];edit_new_goal=set_goal;target_goal=[REF(all_goals)]'>Set goal</a></center></td>"
			dat += "<td width='15%'><center><a href='?src=[REF(src)];edit_new_goal=set_level;target_goal=[REF(all_goals)]'>Set intensity</a></center></td>"
			dat += "<td width='25%'><center><a href='?src=[REF(src)];edit_new_goal=set_notes;target_goal=[REF(all_goals)]'>Set notes</a></center></td>"
			dat += "<td width='30%'><table align='center'>"
			dat += "<td><a href='?src=[REF(src)];edit_new_goal=add_sim_objectives;target_goal=[REF(all_goals)]'>Set similar objectives</a></td>"
			dat += "<td><a href='?src=[REF(src)];edit_new_goal=clear_sim_objectives;target_goal=[REF(all_goals)]'>Clear similar objectives</a></td>"
			dat += "<td><a href='?src=[REF(src)];edit_new_goal=toggle_check_all_objectives;target_goal=[REF(all_goals)]'>[all_goals.check_all_objectives? "Check All Successes":"Check First Success"]</a></td>"
			dat += "</table></td>"
			dat += "</tr>"
			dat += "<tr><td width='30%' valign='top'>[TextPreview(all_goals.goal, 210)]</td>"
			dat += "<td width='15%' valign='top'><center><span style='border: 1px solid #161616; background-color: [intensity_color];'> [all_goals.intensity] </span></center></td>"
			dat += "<td width='25%' valign='top'>[TextPreview(all_goals.notes, 140)]</td>"
			dat += "<td width='30%' valign='top'>"
			for(var/datum/objective/objectives as anything in all_goals.similar_objectives)
				if(LAZYLEN(all_goals.similar_objectives) > TRAITOR_PLUS_MAX_SIMILAR_OBJECTIVES)
					break
				dat += "[TextPreview(objectives.explanation_text, 100)]	<a href='?src=[REF(src)];edit_new_goal=cut_sim_objectives;target_goal=[REF(all_goals)];target_objective=[REF(objectives)]'>(Remove objective)</a><br>"
			dat += "</td></tr>"
			dat += "<a href='?src=[REF(src)];remove_goal=[REF(all_goals)]'>Remove goal</a>"
			dat += "</table><br>"
			count++

	dat += "<br><a href='?src=[REF(src)];add_new_goal=1'>Add a new goal</a>"
	if(!should_equip)
		dat += "<br><a href='?src=[REF(src)];finalize_goals=1'>Finalize goals (They can still be edited in the future!)</a>"
		dat += "<br><i>Based on your current goals, finalizing now will grant you [get_traitor_points_from_goals()] [(traitor_kind == TRAITOR_AI) ? "processing units" : "telecrystals"].</i>"

	return dat
	*/

/datum/adv_traitor_panel
	var/mob/viewer
	var/datum/antagonist/traitor/traitor_plus/owner_datum

/datum/adv_traitor_panel/New(mob/user, datum/antagonist/traitor/traitor_plus/owner_datum)
	if(istype(user))
		viewer = user
	else
		var/client/user_client = user
		viewer = user_client.mob

	src.owner_datum = owner_datum

/datum/adv_traitor_panel/ui_close()
	qdel(src)

/datum/adv_traitor_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_AdvancedTraitorPanel")
		ui.open()

/datum/adv_traitor_panel/ui_state(mob/user)
	if(viewer != owner_datum.owner.current)
		to_chat(user, "You are viewing [owner_datum.owner.current]'s advanced traitor panel as an admin.")
		message_admins("[ADMIN_LOOKUPFLW(user)] is viewing [ADMIN_LOOKUPFLW(owner_datum.owner.current)]'s advanced traitor panel as an admin.")
		return GLOB.admin_state
	else
		return GLOB.always_state

/datum/adv_traitor_panel/ui_data(mob/user)
	var/list/data = list()
	data["name"] = owner_datum.name
	data["employer"] = owner_datum.employer
	data["backstory"] = owner_datum.backstory
	data["goals_finalized"] = owner_datum.should_equip

	var/goal_num = 0
	for(var/datum/advanced_antag_goal/found_goal in owner_datum.our_goals)
		var/list/goal_data = list(
			id = ++goal_num,
			ref = REF(found_goal)
			goal = found_goal.goal,
			intensity = found_goal.intensity,
			notes = found_goal.notes,
			objective_data = null,
			)
		if(LAZYLEN(found_goal.similar_objectives))
			var/list/found_objective_data = list()
			for(var/datum/objective/found_objective in found_goal.similar_objectives)
				found_objective_data += found_objective.explanation_text
			goal_data["objective_data"] = found_objective_data
		data["goals"] += list(goal_data)

	return data

/datum/adv_traitor_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!owner_datum)
		CRASH("Advanced traitor panel being operated with no advanced traitor datum.")

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
			if(LAZYLEN(owner_datum.our_goals) > TRAITOR_PLUS_MAX_GOALS)
				to_chat(usr, "Max amount of goals reached.")
			else
				owner_datum.add_advanced_goal()
				to_chat(usr, "Goal added.")
			. = TRUE

		if("finalize_goals")
			if(!owner_datum.should_equip)
				owner_datum.should_equip = TRUE
				owner_datum.finalize_traitor()
				owner_datum.modify_traitor_points()
				owner_datum.log_goals_on_finalize()
			. = TRUE

		if("set_goal_text")
			var/datum/advanced_antag_goal/edited_goal = locate(params["ref"]) in owner_datum.our_goals
			edited_goal.set_goal_text(params["newgoal"])
