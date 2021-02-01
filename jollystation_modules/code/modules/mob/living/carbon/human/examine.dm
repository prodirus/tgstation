/// -- Extension of /mob/living/carbon/human/examine(). --

/// Defines for the message to display when finding more info.
#define ADDITIONAL_INFO_RECORDS (1<<0)
#define ADDITIONAL_INFO_EXPLOITABLE (1<<1)
#define ADDITIONAL_INFO_FLAVOR (1<<2)

// Mob is the person being examined. User is the one doing the examining.
/mob/living/carbon/human/examine(mob/user)
	. = ..()
	// The string we return, formatted.
	var/expanded_examine = "<span class='info'>"
	// Whether or not we would have additional info on `examine_more()`.
	var/has_additional_info
	// Who's identity are we dealing with? In most cases it's the same as [src], but it could be disguised people.
	var/mob/living/carbon/human/known_identity = get_visible_identity(user)

	// Admins can view all records.
	if(user.client.holder && isAdminObserver(user))
		// Formatted output list of records.
		var/list/line = list()

		if(client.prefs.flavor_text)
			line += "<a href='?src=[REF(src)];flavor_text=1'>\[FLAVOR\]</a>"
		if(client.prefs.general_records)
			line += "<a href='?src=[REF(src)];general_records=1'>\[GEN\]</a>"
		if(client.prefs.security_records)
			line += "<a href='?src=[REF(src)];security_records=1'>\[SEC\]</a>"
		if(client.prefs.medical_records)
			line += "<a href='?src=[REF(src)];medical_records=1'>\[MED\]</a>"
		if(client.prefs.exploitable_info)
			line += "<a href='?src=[REF(src)];exploitable_info=1'>\[EXP\]</a>"

		expanded_examine += line.Join()

	if(client && known_identity?.client)
		// If the client has flavor text set.
		if(known_identity.client.prefs.flavor_text)
			expanded_examine += known_identity.get_flavor_text(TRUE)
			has_additional_info |= ADDITIONAL_INFO_FLAVOR

		// Typecasted user into human, so we can check their ID for access.
		var/mob/living/carbon/human/hud_wearer = user
		// A list of our user's acccess.
		var/list/access = istype(hud_wearer) ? hud_wearer.wear_id?.GetAccess() : null
		// Antagonists can see expoitable information.
		if(user.mind?.antag_datums && known_identity.client.prefs.exploitable_info)
			for(var/antag_datum in user.mind.antag_datums)
				var/datum/antagonist/curious_antag = antag_datum
				if(!(curious_antag.antag_flags & CAN_SEE_EXPOITABLE_INFO))
					continue
				has_additional_info |= ADDITIONAL_INFO_EXPLOITABLE
				break
		// Medhuds can see medical records.
		if(known_identity.client.prefs.medical_records && HAS_TRAIT(hud_wearer, TRAIT_MEDICAL_HUD) && access && (ACCESS_MEDICAL in access))
			has_additional_info |= ADDITIONAL_INFO_RECORDS
		// Sechuds can see security records.
		if(known_identity.client.prefs.security_records && HAS_TRAIT(hud_wearer, TRAIT_SECURITY_HUD) && access && (ACCESS_SECURITY in access))
			has_additional_info |= ADDITIONAL_INFO_RECORDS

		var/added_info = ""
		if(has_additional_info & ADDITIONAL_INFO_FLAVOR)
			added_info = "longer flavor text"
		if(has_additional_info & ADDITIONAL_INFO_EXPLOITABLE)
			added_info = "[added_info ? "[added_info], exploitable information" : "exploitable information"]"
		if(has_additional_info & ADDITIONAL_INFO_RECORDS)
			added_info = "[added_info ? "[added_info], and past records" : "past records"]"

		expanded_examine += "<span class='smallnoticeital'>This individual has [added_info] if you <b>examine closer.<b/></span>\n"

	// if the mob doesn't have a client, show how long they've been disconnected for.
	else if(!client && last_connection_time)
		expanded_examine += "<span class='info'><i>[p_theyve(TRUE)] been unresponsive for [round((world.time - last_connection_time) / (60*60), 0.1)] minute(s).</i></span>\n"

	if(length(expanded_examine) >= 20)
		expanded_examine += "*---------*</span>\n"
		. += expanded_examine

	return .

// This isn't even an extension of examine_more this is the only definition for human/examine_more, isn't that neat?
/mob/living/carbon/human/examine_more(mob/user)
	. = ..()
	// Who's identity are we dealing with? In most cases it's the same as [src], but it could be disguised people.
	var/mob/living/carbon/human/known_identity = get_visible_identity(user)

	if(client && known_identity?.client)
		return . + "<span class='info'>[known_identity.get_flavor_text(FALSE)][known_identity.get_records_text(user)]</span>"

/* Determine if the current mob's real identity is visible.
 * This probably has a lot of edge cases that will get missed but we can find those later.
 * (There's gotta be a helper proc for this that already exists in the code, right?)
 *
 * returns a reference to a mob -
 *	- returns SRC if [src] isn't disguised, or is wearing their id / their name is visible
 *	- returns another mob if [src] is disguised as someone that exists in the world
 * returns null otherwise.
 */
/mob/living/carbon/human/proc/get_visible_identity(mob/examiner)
	// your identity is always known to you
	if(examiner == src)
		return src

	// whether their face is covered
	var/face_obscured = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if(!face_obscured)
		return src

	// What name they show up as
	var/shown_name = get_visible_name()
	if(shown_name == "Unknown")
		return null
	else if(shown_name == real_name)
		return src

	// if we're disguised as someone, return them instead
	for(var/client/clients in GLOB.clients)
		if(clients.mob.real_name == shown_name)
			return clients.mob

	return null

// Returns the mob's flavor text if it has any.
/mob/living/carbon/human/proc/get_flavor_text(shorten = TRUE)
	if(!client)
		CRASH("get_flavor_text() called on something without a client")

	if(!client.prefs)
		CRASH("get_flavor_text() called on something without a saved data prefs")

	if(!client.prefs.flavor_text)
		return null

	/// Returned text.
	var/returned_flavor = ""
	/// The text we display, formatted
	var/displayed_flavor_text = "<span class='info'><i>"
	/// The raw flavor text.
	var/found_flavor_text = client.prefs.flavor_text
	// Shorten the flavor text if it exceeds our limit and we are told to.
	if(shorten && length(found_flavor_text) > EXAMINE_FLAVOR_MAX_DISPLAYED)
		displayed_flavor_text += trim(found_flavor_text, EXAMINE_FLAVOR_MAX_DISPLAYED)
		displayed_flavor_text += "... </i><a href='?src=[REF(src)];flavor_text=1'>\[More\]</a>"
	else
		displayed_flavor_text += found_flavor_text
		displayed_flavor_text += "</i>"

	displayed_flavor_text += "</span>\n"
	returned_flavor = displayed_flavor_text

	return returned_flavor

// Returns href buttons to the mob's records text - exploitable stuff, security, and medical.
/mob/living/carbon/human/proc/get_records_text(mob/living/carbon/human/examiner)
	if(!client)
		CRASH("get_records_text() called on something without a client")

	if(!client.prefs)
		CRASH("get_records_text() called on something without a saved data prefs")

	if(!examiner)
		CRASH("get_records_text() called without a user argument - proc is not implemented for null examiner")

	// Record links, formatted, to return.
	var/returned_links = ""
	// A list of our user's acccess.
	var/list/access = istype(examiner) ? examiner.wear_id?.GetAccess() : null

	// Antagonists can see exploitable info.
	if(examiner.mind?.antag_datums && client.prefs.exploitable_info)
		for(var/antag_datum in examiner.mind.antag_datums)
			var/datum/antagonist/curious_antag = antag_datum
			if(!(curious_antag.antag_flags & CAN_SEE_EXPOITABLE_INFO))
				continue
			returned_links += "<a href='?src=[REF(src)];exploitable_info=1'>\[Exploitable Info\]</a>"
			break
	// Medhuds can see medical records.
	if(client.prefs.medical_records && HAS_TRAIT(examiner, TRAIT_MEDICAL_HUD) && access && (ACCESS_MEDICAL in access))
		returned_links += "<a href='?src=[REF(src)];medical_records=1'>\[Past Medical Records\]</a>"
	// Sechuds can see security records.
	if(client.prefs.security_records && HAS_TRAIT(examiner, TRAIT_SECURITY_HUD) && access && (ACCESS_SECURITY in access))
		returned_links += "<a href='?src=[REF(src)];security_records=1'>\[Past Security Records\]</a>"

	return returned_links

#undef ADDITIONAL_INFO_RECORDS
#undef ADDITIONAL_INFO_EXPLOITABLE
#undef ADDITIONAL_INFO_FLAVOR
