/// Advanced heretic datum - advanced traitor, but for heretics!
/datum/antagonist/heretic/heretic_plus
	name = "Advanced Heretic"
	give_equipment = FALSE
	give_objectives = FALSE
	var/static/list/heretic_objectives = list("sacrifice" = /datum/objective/sacrifice_ecult)

/datum/antagonist/heretic/heretic_plus/on_gain()
	name = "Heretic"

	if(!GLOB.admin_objective_list)
		generate_admin_objective_list()

	var/list/objectives_to_choose = GLOB.admin_objective_list.Copy() - blacklisted_similar_objectives + heretic_objectives
	linked_advanced_datum = new /datum/advanced_antag_datum/heretic(src)
	linked_advanced_datum.setup_advanced_antag()
	linked_advanced_datum.possible_objectives = objectives_to_choose
	return ..()

/datum/antagonist/heretic/heretic_plus/on_removal()
	qdel(linked_advanced_datum)
	return ..()

/datum/antagonist/heretic/heretic_plus/greet()
	linked_advanced_datum.greet_message(owner.current)

/datum/antagonist/heretic/heretic_plus/equip_cultist()
	. = ..()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ecult_op.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)//subject to change
	to_chat(owner, "<span class='boldannounce'>You are the Heretic!</span>")

/datum/antagonist/heretic/heretic_plus/roundend_report()
	var/list/parts = list()

	var/datum/advanced_antag_datum/heretic/our_heretic = linked_advanced_datum
	parts += printplayer(owner)
	if(our_heretic.sacrifices_enabled)
		parts += "<b>Sacrifices Made:</b> [total_sacrifices]"
	else
		parts +="<b>The heretic gave up the rite of sacrifice!</b>"

	if(LAZYLEN(linked_advanced_datum.our_goals))
		var/count = 1
		for(var/datum/advanced_antag_goal/goal in linked_advanced_datum.our_goals)
			parts += goal.get_roundend_text(count)
			count++
		if(our_heretic.ascension_enabled)
			if(ascended)
				parts += "<span class='greentext big'>THE HERETIC ASCENDED!</span>"
		else
			parts += "<b>The heretic gave up the rite of ascension!</b>"

	if(give_equipment)

		parts += "The heretic was bestowed [our_heretic.starting_points] influences in their initial Codex."
		parts += "<b>Knowledge Researched:</b> "

		var/list/knowledge_message = list()
		var/list/knowledge = get_all_knowledge()
		for(var/datum/eldritch_knowledge/found_knowledge as anything in knowledge)
			knowledge_message += "[found_knowledge.name]"
		parts += knowledge_message.Join(", ")
	else
		parts += "<b>The heretic never recieved their Codex!</b> "

	return parts.Join("<br>")

/datum/antagonist/heretic/heretic_plus/roundend_report_footer()
	return "<br>And thus closes another book on board [station_name()]."

/// An extra button for the TP, to open the goal panel
/datum/antagonist/heretic/heretic_plus/get_admin_commands()
	. = ..()
	.["View Goals"] = CALLBACK(src, .proc/show_advanced_traitor_panel, usr)

/// An extra button for check_antagonists, to open the goal panel
/datum/antagonist/heretic/heretic_plus/antag_listing_commands()
	. = ..()
	. += "<a href='?_src_=holder;[HrefToken()];admin_check_goals=[REF(src)]'>Show Goals</a>"

/datum/advanced_antag_datum/heretic
	name = "Advanced Heretic"
	employer = "The Mansus"
	starting_points = 0
	style = "wizard"
	var/datum/antagonist/heretic/heretic_plus/our_heretic
	var/ascension_enabled = FALSE
	var/sacrifices_enabled = FALSE

/datum/advanced_antag_datum/heretic/New(datum/antagonist/linked_antag)
	. = ..()
	our_heretic = linked_antag

/datum/advanced_antag_datum/heretic/modify_antag_points()
	starting_points = get_antag_points_from_goals()
	var/mob/living/carbon/carbon_heretic = linked_antagonist.owner.current
	for(var/obj/item/forbidden_book/codex as anything in carbon_heretic.get_all_gear())
		if(!istype(codex))
			continue
		codex.charge = starting_points
		break

/datum/advanced_antag_datum/heretic/get_antag_points_from_goals()
	var/finalized_influences = HERETIC_PLUS_INITIAL_INFLUENCE
	var/max_influnces = HERETIC_PLUS_MAX_INFLUENCE
	if(!ascension_enabled)
		finalized_influences += 3
		max_influnces += HERETIC_PLUS_NO_ASCENSION_MAX
	if(!sacrifices_enabled)
		finalized_influences += 3
		max_influnces += HERETIC_PLUS_NO_SAC_MAX

	for(var/datum/advanced_antag_goal/goal in our_goals)
		finalized_influences += (goal.intensity / 3)

	return min(round(finalized_influences), max_influnces)

/datum/advanced_antag_datum/heretic/get_finalize_text()
	return {"Finalizing will deliver you a Codex Cicatrix with [get_antag_points_from_goals()] influence charges and a Living heart. \
If you finalize now, you will be [ascension_enabled ? "allowed to ascend": "disallowed from ascending"], \
and, you will be [sacrifices_enabled ? "allowed to sacrifice": "disallowed from sacrificing"] crew members. \
You can still edit your goals after finalizing, but you will not be able to re-enable ascension or sacrificing!"}

/datum/advanced_antag_datum/heretic/post_finalize_actions()
	. = ..()
	if(!.)
		return

	our_heretic.give_equipment = TRUE
	our_heretic.equip_cultist()

/datum/objective/sacrifice_ecult/admin_edit(mob/admin)
	var/new_amount = input(admin,"How many sacrifices?", "Sacs", target_amount) as num|null
	if(new_amount)
		target_amount = clamp(new_amount, 1, 9)
	update_explanation_text()
