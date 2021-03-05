
#define TRAITOR_PLUS_INITIAL_TC 8
#define TRAITOR_PLUS_MAX_TC 40

#define TRAITOR_PLUS_INITIAL_MALF_POINTS 20
#define TRAITOR_PLUS_MAX_MALF_POINTS 60

#define TRAITOR_PLUS_MAX_GOALS 5
#define TRAITOR_PLUS_MAX_SIMILAR_OBJECTIVES 5

#define TRAITOR_PLUS_MAX_GOAL_LENGTH 250
#define TRAITOR_PLUS_MAX_NOTE_LENGTH 175

#define TRAITOR_PLUS_INTENSITIES list( \
	"5 = Mass killings, destroying entire departments", \
	"4 = Mass sabotage (engine delamination)", \
	"3 = Assassination / Grand Theft", \
	"2 = Kidnapping / Theft", \
	"1 = Minor theft or basic antagonizing" )

/datum/game_mode/traitor_plus
	name = "traitor plus"
	config_tag = "traitor_plus"
	report_type = "traitor_plus"
	antag_flag = ROLE_TRAITOR
	false_report_weight = 15
	restricted_jobs = list("Cyborg") // Sorry, no cyborg traitors
	//protected_jobs = list("Prisoner","Security Officer", "Warden", "Detective", "Head of Security", "Captain") // No protected jobs!
	required_players = 1
	reroll_friendly = FALSE

	announce_span = "danger"
	announce_text = "There are antagonistic agents on the station!\n	\
	<span class='danger'>Traitors</span>: Set an objective and complete it!\n	\
	<span class='notice'>Crew</span>: Ensure the station and crew survive!"

	var/give_antag_lower_timer = 8 MINUTES
	var/give_antag_upper_timer = 12 MINUTES

	var/list/datum/mind/pre_chosen_traitors = list()
	var/antag_datum = /datum/antagonist/traitor/traitor_plus


/datum/game_mode/traitor_plus/pre_setup()
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	var/num_traitors = 1
	var/tsc = CONFIG_GET(number/traitor_scaling_coeff)
	if(tsc)
		num_traitors = max(1, min(round(num_players() / (tsc * 2)) + 2, round(num_players() / tsc)))
	else
		num_traitors = max(1, min(num_players(), rand(2, 4)))

	for(var/j = 0, j < num_traitors, j++)
		if (!antag_candidates.len)
			break
		var/datum/mind/traitor = antag_pick(antag_candidates)
		pre_chosen_traitors += traitor
		message_admins("[ADMIN_LOOKUPFLW(traitor)] has been selected as a potential advanced traitor. They will recieve traitor status in [give_antag_lower_timer / (60*10)] to [give_antag_upper_timer / (60*10)] minutes.")
		log_game("[key_name(traitor)] has been selected as a potential advanced traitor.")
		antag_candidates.Remove(traitor)

	for(var/antag in pre_chosen_traitors)
		GLOB.pre_setup_antags += antag
	return TRUE

/datum/game_mode/traitor_plus/post_setup()
	for(var/datum/mind/traitor in pre_chosen_traitors)
		addtimer(CALLBACK(traitor, /datum/mind.proc/make_advanced_traitor, antag_datum, ROLE_TRAITOR, restricted_jobs), rand(give_antag_lower_timer, give_antag_upper_timer))
		GLOB.pre_setup_antags -= traitor
	..()

	return TRUE

/datum/game_mode/traitor_plus/proc/mulligan_choice()
	var/give_mulligan_lower_time = 0
	var/give_mulligan_upper_timer = 2 MINUTES
	if (!antag_candidates.len)
		message_admins("An advanced traitor that was chosen to spawn was mulliganed, and no replacement was found.")
		log_game("An advanced traitor failed to spawn and no mulligan was selected.")
		return FALSE

	var/datum/mind/traitor = antag_pick(antag_candidates)
	addtimer(CALLBACK(traitor, /datum/mind.proc/make_advanced_traitor, antag_datum, ROLE_TRAITOR, restricted_jobs), rand(0, 2 MINUTES))
	message_admins("An advanced traitor that was chosen to spawn was mulliganed and [ADMIN_LOOKUPFLW(traitor)] has been selected as a replacement. They will recieve traitor status in [give_mulligan_lower_time / (60*10)] to [give_mulligan_upper_timer / (60*10)] minutes.")
	log_game("An advanced traitor failed to spawn and [key_name(traitor)] has been selected as a replacement.")
	antag_candidates.Remove(traitor)

	return TRUE

/datum/game_mode/traitor_plus/generate_report()
	return "Recent reports of agents from a wide variety of branches, employers, and origins have been spreading around the sector. While we're sure it's probably nothing, \
			expect the unexpected - if they happen to be true, anyone could be dangerous enemy of the corporation, even who you least expect it."

/datum/antagonist/traitor/traitor_plus
	name = "Advanced Traitor"
	// We change this
	hijack_speed = 0.5
	// We change this
	employer = "The Syndicate"
	// No traitor objectives
	give_objectives = FALSE
	// No codewords
	should_give_codewords = FALSE
	// We equip our traitor later
	should_equip = FALSE
	// Same here
	finalize_antag = FALSE
	// What's our story
	var/backstory = ""
	// How much TC we start with
	var/starting_tc = 20
	// Lazylist of our goals
	var/list/datum/advanced_antag_goal/goals
	// Some blacklsited custom objectives we don't want showing up in the similar objectives pool
	var/static/list/blacklisted_custom_objectives = list("custom", "absorb", "nuclear")

/datum/antagonist/traitor/traitor_plus/on_gain()
	setup_advanced_traitor()
	antag_memory += "Use the <b>\"Antagonist - Set Goals\"</b> verb to set your goals.<br>"

	var/datum/objective/custom/custom_objective = new
	custom_objective.explanation_text = "Set your custom goals via the IC tab."
	objectives += custom_objective

	return ..()

/datum/antagonist/traitor/traitor_plus/on_removal()
	remove_verb(src, /mob/verb/open_advanced_traitor_panel)
	QDEL_LIST(goals)
	return ..()

/datum/antagonist/traitor/traitor_plus/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are an antagonist!</span>")
	to_chat(owner.current, "<span class='danger'>You are a story driven antagonist! You can set your goals to whatever you think would make an interesting story or round.</span>")
	to_chat(owner.current, "<span class='danger'>Once you set at least 2 goals, you'll be given an uplink - the more you set, and the higher the intensity, the more telecrystals you'll be afforded.</span>")
	owner.current.playsound_local(get_turf(owner.current), 'jollystation_modules/sound/radiodrum.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/antagonist/traitor/traitor_plus/roundend_report()
	var/list/result = list()

	result += printplayer(owner)
	result += "<b>[owner]</b> was a/an <b>[name]</b>[employer? " employed by <b>[employer]</b>":""]."
	if(backstory)
		result += "<b>[owner]'s</b> backstory was the following: <br>[backstory]<br>"

	var/TC_uses = 0
	var/uplink_true = FALSE
	var/purchases = ""

	if(should_equip)
		LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
		var/datum/uplink_purchase_log/H = GLOB.uplink_purchase_logs_by_key[owner.key]
		if(H)
			uplink_true = TRUE
			TC_uses = H.total_spent
			purchases += H.generate_render(FALSE)

	if(LAZYLEN(goals))
		var/count = 1
		for(var/datum/advanced_antag_goal/goal as anything in goals)
			result += goal.get_roundend_text(count)
			count++
		if(uplink_true)
			result += "<br>They were afforded <b>[starting_tc]</b> tc to accomplish these tasks."

	if(uplink_true)
		var/uplink_text = "(used [TC_uses] TC) [purchases]"
		result += uplink_text
		if (contractor_hub)
			result += contractor_round_end()
	else if (!should_equip)
		result += "<br>The [name] never obtained their uplink!"

	return result.Join("<br>")

/datum/antagonist/traitor/traitor_plus/roundend_report_footer()
	return "<br>And thus ends another story on board [station_name()]."

/// Give the traitor the buttons to open their ui
/datum/antagonist/traitor/traitor_plus/proc/setup_advanced_traitor()
	name = "Traitor"
	show_advanced_traitor_panel(owner.current)
	add_verb(owner.current, /mob/verb/open_advanced_traitor_panel)

/// A verb to open up their panel
/mob/verb/open_advanced_traitor_panel()
	set name = "Antagonist - Set Goals"
	set category = "IC"

	var/datum/antagonist/traitor/traitor_plus/our_antag_datum = mind?.has_antag_datum(/datum/antagonist/traitor/traitor_plus)
	if(!our_antag_datum)
		to_chat(src, "You shouldn't have this!")
		remove_verb(src, /mob/verb/open_advanced_traitor_panel)
		return

	our_antag_datum.show_advanced_traitor_panel(src)

/datum/mind/proc/make_advanced_traitor(datum/antagonist/traitor/traitor_plus/our_antag_datum, traitor_name, restricted_jobs, forced = FALSE)
	var/go_ahead = TRUE
	if(QDELETED(src)) // If our mind is gone, nowhere to put the antag
		go_ahead = FALSE
	if(!current) // No body = not a good antag
		go_ahead = FALSE
	if(!current.client) // No client = not a good antag
		go_ahead = FALSE
	if(current.stat == DEAD) // Dead people = not a good antag
		go_ahead = FALSE
	if(has_antag_datum(our_antag_datum)) // If we're already an advanced traitor, don't try again
		go_ahead = FALSE

	if(forced || go_ahead)
		var/datum/antagonist/traitor/new_antag = new our_antag_datum()
		special_role = traitor_name
		restricted_roles = restricted_jobs
		add_antag_datum(new_antag)
	else
		var/datum/game_mode/traitor_plus/our_mode = SSticker.mode
		if(istype(our_mode))
			our_mode.mulligan_choice()

/// Show them the panel
/datum/antagonist/traitor/traitor_plus/proc/show_advanced_traitor_panel(mob/user)
	var/dat = ""
	dat += "<div align='center'><a href='?src=[REF(src)];set_name=1'>Set Antagonist Name:</a> [name]				"
	dat += "<a href='?src=[REF(src)];set_employer=1'>Set Antagonist Employer:</a> [employer]</div>"
	dat += "<hr>"

	var/intensity_color = "#f00"

	if(LAZYLEN(goals))
		var/count = 1
		for(var/datum/advanced_antag_goal/all_goals as anything in goals)
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
			dat += "<tr><td><center><a href='?src=[REF(src)];edit_new_goal=set_goal;target_goal=[REF(all_goals)]'>Set goal</a></center></td>"
			dat += "<td><center><a href='?src=[REF(src)];edit_new_goal=set_level;target_goal=[REF(all_goals)]'>Set intensity</a></center></td>"
			dat += "<td><center><a href='?src=[REF(src)];edit_new_goal=set_notes;target_goal=[REF(all_goals)]'>Set notes</a></center></td>"
			dat += "<td><center><a href='?src=[REF(src)];edit_new_goal=add_sim_objectives;target_goal=[REF(all_goals)]'>Set similar objectives</a> \
						<a href='?src=[REF(src)];edit_new_goal=clear_sim_objectives;target_goal=[REF(all_goals)]'>(Clear similar objectives)</a></center></td></tr>"
			dat += "<tr><td width='35%' valign='top'>[TextPreview(all_goals.goal, 210)]</td>"
			dat += "<td width='10%' valign='top'><center><span style='border: 1px solid #161616; background-color: [intensity_color];'> [all_goals.intensity] </span></center></td>"
			dat += "<td width='25%' valign='top'>[TextPreview(all_goals.notes, 140)]</td>"
			dat += "<td width='30%' valign='top'>"
			for(var/datum/objective/objectives as anything in all_goals.similar_objectives)
				if(LAZYLEN(all_goals.similar_objectives) > TRAITOR_PLUS_MAX_SIMILAR_OBJECTIVES)
					break
				dat += "[TextPreview(objectives.explanation_text, 100)]	<a href='?src=[REF(src)];edit_new_goal=cut_sim_objectives;target_goal=[REF(all_goals)];target_objective=[REF(objectives)]'>(Remove objective)</a><br>"
			dat += "</td></tr>"
			dat += "<a href='?src=[REF(src)];remove_goal=1;target_goal=[REF(all_goals)]'>Remove goal</a>"
			dat += "</table><br>"
			count++

	dat += "<br><a href='?src=[REF(src)];add_new_goal=1'>Add a new goal</a>"
	if(!should_equip)
		dat += "<br><a href='?src=[REF(src)];finalize_goals=1'>Finalize goals (They can still be edited in the future!)</a>"
		dat += "<br><i>Based on your current goals, finalizing now will grant you [get_traitor_points_from_goals()] [(traitor_kind == TRAITOR_AI) ? "processing units" : "telecrystals"].</i>"

	winshow(user, "advanced_traitor_goals", TRUE)
	var/datum/browser/adv_traitor_panel = new(user, "advanced_traitor_goals", "", 800, 600)
	adv_traitor_panel.window_options = "can_close=1;can_minimize=0;can_maximize=0;can_resize=0;titlebar=1;"
	adv_traitor_panel.set_content(dat)
	adv_traitor_panel.open(FALSE)
	onclose(user, "advanced_traitor_goals")

/datum/antagonist/traitor/traitor_plus/Topic(href, href_list)
	. = ..()
	if(href_list["add_new_goal"])
		if(LAZYLEN(goals) > TRAITOR_PLUS_MAX_GOALS)
			to_chat(usr, "Max amount of goals reached.")
			return
		add_advanced_goal()

	if(href_list["edit_new_goal"])
		var/datum/advanced_antag_goal/edited_goal = locate(href_list["target_goal"])
		if(!edited_goal)
			return

		switch(href_list["edit_new_goal"])
			// Set some things about the goal
			if("set_goal")
				var/new_goal = input(usr, "What's your goal?", "Add Goal", "") as message|null
				if(new_goal)
					edited_goal.set_goal_text(strip_html_simple(new_goal, TRAITOR_PLUS_MAX_GOAL_LENGTH))
				else
					return

			if("set_level")
				var/new_intensity = input(usr, "What's the intensity of this goal?", "Set Intensity", "") as null|anything in sortList(TRAITOR_PLUS_INTENSITIES)
				if(new_intensity)
					edited_goal.set_intensity(text2num(copytext_char(new_intensity, 1, 2)))
				else
					return

			if("set_notes")
				var/new_notes = input(usr, "Extra notes (how you'll accomplish it, reasoning for it, etc)", "Add notes", "") as message|null
				edited_goal.notes = strip_html_simple(new_notes, TRAITOR_PLUS_MAX_NOTE_LENGTH)

			// Add, remove, and clear objectives from the similar objectives list
			if("add_sim_objectives")
				if(LAZYLEN(goals) > TRAITOR_PLUS_MAX_SIMILAR_OBJECTIVES)
					to_chat(usr, "Max amount of similar objectives reached for this goal.")
					return

				if(!GLOB.admin_objective_list)
					generate_admin_objective_list()
				var/list/edited_similar_objectives = LAZYCOPY(edited_goal.similar_objectives)
				var/list/objectives_to_choose = GLOB.admin_objective_list.Copy() - blacklisted_custom_objectives
				var/datum/objective/new_objective_type = input("Add an objective:", "Objective type", null) as null|anything in objectives_to_choose
				new_objective_type = objectives_to_choose[new_objective_type]
				var/datum/objective/added_objective = new new_objective_type
				if(new_objective_type)
					edited_similar_objectives.Add(added_objective)
					added_objective.admin_edit(usr)
				else
					return

				edited_goal.similar_objectives = edited_similar_objectives

			if("cut_sim_objectives")
				var/list/edited_similar_objectives = edited_goal.similar_objectives.Copy()
				var/datum/objective/removed_objective = locate(href_list["target_objective"])
				if(edited_similar_objectives.Remove(removed_objective))
					qdel(removed_objective)
					edited_goal.similar_objectives = edited_similar_objectives
				else
					return

			if("clear_sim_objectives")
				if(!LAZYLEN(edited_goal.similar_objectives))
					return
				QDEL_LIST(edited_goal.similar_objectives)

	if(href_list["remove_goal"])
		remove_advanced_goal(locate(href_list["target_goal"]))

	if(href_list["finalize_goals"])
		if(should_equip)
			return
		should_equip = TRUE
		finalize_traitor()
		modify_traitor_points()
		//objectives.Cut()

	if(href_list["set_name"])
		var/new_name = input(usr, "Set your antagonist name:", "Set name", "") as message|null
		if(new_name)
			name = strip_html_simple(new_name, MAX_NAME_LEN)
		else
			return

	if(href_list["set_employer"])
		var/new_employer = input(usr, "Set your antagonist employer:", "Set employer", "") as message|null
		employer = strip_html_simple(new_employer, MAX_NAME_LEN)

	if(href_list["set_backstory"])
		var/new_backstory = input(usr, "Set your antagonist backstory:", "Set backstory", "") as message|null
		backstory = strip_html_simple(new_backstory, MAX_MESSAGE_LEN)

	show_advanced_traitor_panel(usr)
	return TRUE

/// Give the traitor their uplink
/datum/antagonist/traitor/traitor_plus/proc/modify_traitor_points()
	switch(traitor_kind)
		if(TRAITOR_HUMAN)
			var/datum/component/uplink/made_uplink = owner.find_syndicate_uplink()
			if(!made_uplink)
				return

			starting_tc = get_traitor_points_from_goals()
			made_uplink.telecrystals = starting_tc
			hijack_speed = (20 / starting_tc) // 20 tc traitor = 0.5 (default traitor hijack speed)
		if(TRAITOR_AI)
			var/mob/living/silicon/ai/traitor_ai = owner.current
			var/datum/module_picker/traitor_ai_uplink = traitor_ai.malf_picker

			starting_tc = get_traitor_points_from_goals()
			traitor_ai_uplink.processing_time = starting_tc
		else
			CRASH("modify_traitor_points() called on an antagonist with no traitor kind set")

/datum/antagonist/traitor/traitor_plus/proc/get_traitor_points_from_goals()
	switch(traitor_kind)
		if(TRAITOR_HUMAN)
			var/finalized_starting_tc = TRAITOR_PLUS_INITIAL_TC
			for(var/datum/advanced_antag_goal/goal as anything in goals)
				finalized_starting_tc += (goal.intensity * 2)

			return min(finalized_starting_tc, TRAITOR_PLUS_MAX_TC)
		if(TRAITOR_AI)
			var/finalized_starting_points = TRAITOR_PLUS_INITIAL_MALF_POINTS
			for(var/datum/advanced_antag_goal/goal as anything in goals)
				finalized_starting_points += (goal.intensity * 5)

			return min(finalized_starting_points, TRAITOR_PLUS_MAX_MALF_POINTS)
		else
			CRASH("get_traitor_points_from_goals() called on an antagonist with no traitor kind set")

/// Add a new goal
/datum/antagonist/traitor/traitor_plus/proc/add_advanced_goal()
	var/datum/advanced_antag_goal/new_goal = new(src)
	LAZYADD(goals, new_goal)

/// Remove an old goal
/datum/antagonist/traitor/traitor_plus/proc/remove_advanced_goal(datum/advanced_antag_goal/old_goal)
	LAZYREMOVE(goals, old_goal)
	qdel(old_goal)

/datum/advanced_antag_goal
	/// Our antag datum
	var/datum/antagonist/our_antag
	/// What's our actual set goal?
	var/goal = ""
	/* How dangerous this goal is
	 * 5 = Mass killings, vaporizing departments
	 * 4 = Mass sabotage (engine delamination)
	 * 3 = Assassination / Grand Theft
	 * 2 = Kidnapping / Theft
	 * 1 = Minor theft or basic antagonizing
	 */
	var/intensity = 0
	// Extra notes about this goal.
	var/notes = ""
	// Similar objective datums we can compare this goal too for success and such
	var/list/datum/objective/similar_objectives

/datum/advanced_antag_goal/New(datum/antagonist/antag_datum, identifier)
	our_antag = antag_datum

/datum/advanced_antag_goal/Destroy()
	. = ..()
	QDEL_LIST(similar_objectives)
	our_antag = null

/datum/advanced_antag_goal/proc/set_goal_text(_goal)
	goal = _goal

/datum/advanced_antag_goal/proc/set_intensity(_intensity)
	if(_intensity)
		intensity = _intensity
	else
		intensity = 1

/* Loop through all our similar objectives and see if we completed them.
 *
 *
 * check_all - whether success is determined with AND (true) or OR (false).
 */
/datum/advanced_antag_goal/proc/check_relative_success(check_all = TRUE)
	for(var/datum/objective/objective as anything in similar_objectives)
		if(check_all)
			if(!objective.check_completion())
				return FALSE
		else
			if(objective.check_completion())
				return TRUE

	return TRUE

/datum/advanced_antag_goal/proc/get_roundend_text(number)
	var/datum/antagonist/our_antag_datum = our_antag
	var/formatted_text = "<br><B>Objective #[number]</B>: [goal]"
	if(LAZYLEN(similar_objectives))
		if(check_relative_success())
			formatted_text += "<br><span class='greentext'> The [our_antag_datum.name] succeeded this goal!</span>"
		else
			formatted_text += "<br><span class='redtext'> The [our_antag_datum.name] failed this goal!</span>"
	if(notes)
		formatted_text += "<br><span class='info'>Extra info they had about this goal: [notes]</span>"

	return formatted_text
