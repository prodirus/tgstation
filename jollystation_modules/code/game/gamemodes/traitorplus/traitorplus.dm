
#define TRAITOR_PLUS_INITIAL_TC 8
#define TRAITOR_PLUS_MAX_TC 40

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
	// If we have given out the uplink

/datum/antagonist/traitor/traitor_plus/on_gain()
	setup_advanced_traitor()
	antag_memory += "Use the <b>\"Antagonist - Set Goals\"</b> verb to set your goals.<br>"
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
		for(var/datum/advanced_antag_goal/goal as anything in goals)
			result += goal.get_roundend_text()
		if(should_equip)
			result += "<br>They were afforded <b>[starting_tc]</b> tc to accomplish these tasks."

	if(uplink_true)
		var/uplink_text = "(used [TC_uses] TC) [purchases]"
		result += uplink_text
		if (contractor_hub)
			result += contractor_round_end()
	else if (!should_equip)
		result += "The [name] never obtained their uplink!"

	return result.Join("<br>")

/// Give the traitor the buttons to open their ui
/datum/antagonist/traitor/traitor_plus/proc/setup_advanced_traitor()
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

/mob/proc/make_advanced_traitor()
	mind?.add_antag_datum(/datum/antagonist/traitor/traitor_plus)

/// Show them the panel
/datum/antagonist/traitor/traitor_plus/proc/show_advanced_traitor_panel(mob/user)
	var/dat = ""
	dat += "<a href='?src=[REF(src)];set_name=1'>Set Antagonist Name:</a> [name]	"
	dat += "<a href='?src=[REF(src)];set_employer=1'>Set Antagonist Employer:</a> [employer]"
	dat += "<hr>"

	var/intensity_color = "#f00"

	if(LAZYLEN(goals))
		var/count = 1
		for(var/datum/advanced_antag_goal/all_goals as anything in goals)
			if(count >= 5)
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
			dat += "<tr><td>[TextPreview(all_goals.goal)]</td>"
			dat += "<td><center><span style='border: 1px solid #161616; background-color: [intensity_color];'>[all_goals.intensity]</span></center></td>"
			dat += "<td>[TextPreview(all_goals.notes)]</td>"
			dat += "<td>"
			for(var/datum/objective/objectives as anything in all_goals.similar_objectives)
				dat += "[objectives.explanation_text]	<a href='?src=[REF(src)];cut_sim_objectives=1;target_goal=[REF(all_goals)];target_objective=[REF(objectives)]'>(Remove objective)</a><br>"
			dat += "</td></tr>"
			dat += "<a href='?src=[REF(src)];remove_goal=1;target_goal=[REF(all_goals)]'>Remove goal</a>"
			dat += "</table><br>"
			count++

	dat += "<br><a href='?src=[REF(src)];add_new_goal=1'>Add a new goal</a>"
	dat += "<br><a href='?src=[REF(src)];finalize_goals=1'>Finalize goals (They can still be edited in the future!)</a>"

	winshow(user, "advanced_traitor_goals", TRUE)
	var/datum/browser/adv_traitor_panel = new(user, "advanced_traitor_goals", "", 950, 750)
	adv_traitor_panel.set_content(dat)
	adv_traitor_panel.open(FALSE)
	onclose(user, "advanced_traitor_goals")

/datum/antagonist/traitor/traitor_plus/Topic(href, href_list)
	. = ..()
	if(href_list["add_new_goal"])
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
					edited_goal.set_goal_text(strip_html_simple(new_goal, MAX_MESSAGE_LEN))
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
				edited_goal.notes = new_notes

			// Add, remove, and clear objectives from the similar objectives list
			if("add_sim_objectives")
				var/list/edited_similar_objectives = LAZYCOPY(edited_goal.similar_objectives)
				if(!GLOB.admin_objective_list)
					generate_admin_objective_list()
				var/datum/objective/new_objective_type = input("Add an objective:", "Objective type", null) as null|anything in GLOB.admin_objective_list
				new_objective_type = GLOB.admin_objective_list[new_objective_type]
				if(new_objective_type)
					edited_similar_objectives.Add(new new_objective_type)
				else
					return

				edited_goal.similar_objectives = edited_similar_objectives

			if("cut_sim_objectives")
				if(!LAZYLEN(edited_goal.similar_objectives))
					return
				var/list/edited_similar_objectives = edited_goal.similar_objectives.Copy()
				var/datum/objective/removed_objective = locate(href_list["target_objective"])
				edited_similar_objectives.Remove(removed_objective)
				edited_goal.similar_objectives = edited_similar_objectives

			if("clear_sim_objectives")
				if(!LAZYLEN(edited_goal.similar_objectives))
					return
				edited_goal.similar_objectives.Cut()

	if(href_list["remove_goal"])
		remove_advanced_goal(locate(href_list["target_goal"]))

	if(href_list["finalize_goals"])
		if(should_equip)
			return
		should_equip = TRUE
		finalize_traitor()
		if(traitor_kind == TRAITOR_HUMAN)
			modify_uplink()

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

/// Give the traitor their uplink
/datum/antagonist/traitor/traitor_plus/proc/modify_uplink()
	var/finalized_starting_tc = TRAITOR_PLUS_INITIAL_TC
	var/datum/component/uplink/made_uplink = owner.find_syndicate_uplink()
	if(!made_uplink)
		return

	for(var/datum/advanced_antag_goal/goal as anything in goals)
		finalized_starting_tc += (goal.intensity * 2)

	finalized_starting_tc = min(finalized_starting_tc, TRAITOR_PLUS_MAX_TC)
	made_uplink.telecrystals = finalized_starting_tc
	starting_tc = finalized_starting_tc

/// Add a new goal
/datum/antagonist/traitor/traitor_plus/proc/add_advanced_goal()
	var/new_identifier = 1
	if(LAZYLEN(goals))
		// slot in our new goal in our first free slot
		for(var/datum/advanced_antag_goal/goal as anything in goals)
			if(goal.id == new_identifier)
				new_identifier++

	var/datum/advanced_antag_goal/new_goal = new(src, new_identifier)
	LAZYADD(goals, new_goal)

/// Remove an old goal
/datum/antagonist/traitor/traitor_plus/proc/remove_advanced_goal(datum/advanced_antag_goal/old_goal)
	LAZYREMOVE(goals, old_goal)
	qdel(old_goal)

/datum/antagonist/traitor/traitor_plus/proc/get_advanced_goal_from_id(identifier)
	for(var/datum/advanced_antag_goal/goal as anything in goals)
		if(goal.id == identifier)
			return goal

/datum/advanced_antag_goal
	/// The ID of our goal
	var/id = 1
	/// Our antag datum (as a weakref)
	var/datum/weakref/our_antag
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
	our_antag = WEAKREF(antag_datum)
	id = identifier

/datum/advanced_antag_goal/Destroy()
	QDEL_LIST(similar_objectives)
	our_antag = null

/datum/advanced_antag_goal/proc/set_goal_text(_goal)
	goal = _goal

/datum/advanced_antag_goal/proc/set_intensity(_intensity)
	if(_intensity)
		intensity = _intensity
	else
		intensity = 1

/// Loop through all our similar objectives and see if we completed them.
/datum/advanced_antag_goal/proc/check_relative_success()
	for(var/datum/objective/objective as anything in similar_objectives)
		if(!objective.check_completion())
			return FALSE
	return TRUE

/datum/advanced_antag_goal/proc/get_roundend_text()
	var/datum/antagonist/our_antag_datum = our_antag?.resolve()
	var/formatted_text = "<br><B>Objective #[id]</B>: [goal]"
	if(LAZYLEN(similar_objectives))
		if(check_relative_success())
			formatted_text += "<span class='greentext'>The [our_antag_datum.name] succeeded this goal</span>"
		else
			formatted_text += "<span class='redtext'>The [our_antag_datum.name] failed this goal!</span>"
	if(notes)
		formatted_text += "<br><br><span class='info'>Extra info they had about this goal: [notes]</span>"

	return formatted_text
