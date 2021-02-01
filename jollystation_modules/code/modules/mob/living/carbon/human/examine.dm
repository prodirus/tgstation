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
	// if our face is obscured - don't show flavor/records for people who are hiding
	var/identity_known = identity_visible()

	if(client)
		// If the client has flavor text set.
		if(identity_known && client.prefs.flavor_text)
			var/displayed_flavor_text = "<span class='info'><i>"
			var/found_flavor_text = client.prefs.flavor_text
			if(length(found_flavor_text) > EXAMINE_FLAVOR_MAX_DISPLAYED)
				displayed_flavor_text += trim(found_flavor_text, EXAMINE_FLAVOR_MAX_DISPLAYED)
				displayed_flavor_text += "... </i><a href='?src=[REF(src)];flavor_text=1'>\[More\]</a>"
				has_additional_info |= ADDITIONAL_INFO_FLAVOR
			else
				displayed_flavor_text += found_flavor_text
				displayed_flavor_text += "</i>"

			displayed_flavor_text += "</span>\n"
			expanded_examine += displayed_flavor_text

		// Typecasted user into human, so we can check their ID for access.
		var/mob/living/carbon/human/hud_wearer = user
		// A list of our user's acccess.
		var/list/access = hud_wearer.wear_id?.GetAccess()
		// Formatted output list of records.
		if(user.client.holder && isobserver(user))
			// Admins can view all records.
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
		else if(identity_known)
			// Antagonists can see expoitable information.
			if(user.mind?.antag_datums && client.prefs.exploitable_info)
				for(var/antag_datum in user.mind.antag_datums)
					var/datum/antagonist/curious_antag = antag_datum
					if(!(curious_antag.antag_flags & CAN_SEE_EXPOITABLE_INFO))
						continue
					has_additional_info |= ADDITIONAL_INFO_EXPLOITABLE
					break
			// Medhuds can see medical records.
			if(client.prefs.medical_records && HAS_TRAIT(hud_wearer, TRAIT_MEDICAL_HUD) && access && (ACCESS_MEDICAL in access))
				has_additional_info |= ADDITIONAL_INFO_RECORDS
			// Sechuds can see security records.
			if(client.prefs.security_records && HAS_TRAIT(hud_wearer, TRAIT_SECURITY_HUD) && access && (ACCESS_SECURITY in access))
				has_additional_info |= ADDITIONAL_INFO_RECORDS

			var/added_info = ""
			if(has_additional_info & ADDITIONAL_INFO_FLAVOR)
				added_info = "longer flavor text"
			if(has_additional_info & ADDITIONAL_INFO_EXPLOITABLE)
				added_info = "[added_info ? "[added_info], exploitable information" : "exploitable information"]"
			if(has_additional_info & ADDITIONAL_INFO_RECORDS)
				added_info = "[added_info ? "[added_info], and past records" : "past records"]"

			expanded_examine += "<span class='smallnoticeital'>This individual has [added_info] if you <b>examine closer.<b/></span>\n"

	// if the mob doesn't have a client, show long long they've been disconnected for.
	else if(last_connection_time)
		expanded_examine += "<span class='info'><i>[p_theyve(TRUE)] been unresponsive for [round((world.time - last_connection_time) / (60*60), 0.1)] minute(s).</i></span>\n"

	if(length(expanded_examine) >= 20)
		expanded_examine += "*---------*</span>\n"
		. += expanded_examine

	return .

// This isn't even an extension of examine_more this is the only definition for human/examine_more, isn't that neat?
/mob/living/carbon/human/examine_more(mob/user)

	var/expanded_examine_more = "<span class='info'>"
	// Typecasted user into human, so we can check their ID for access.
	var/mob/living/carbon/human/hud_wearer = user
	// A list of our user's acccess.
	var/list/access = hud_wearer.wear_id?.GetAccess()

	if(client && identity_visible())
		if(client.prefs.flavor_text)
			var/displayed_flavor_text = "<i>[client.prefs.flavor_text]</i>\n"
			expanded_examine_more += displayed_flavor_text

		if(user.mind?.antag_datums && client.prefs.exploitable_info)
			for(var/antag_datum in user.mind.antag_datums)
				var/datum/antagonist/curious_antag = antag_datum
				if(!(curious_antag.antag_flags & CAN_SEE_EXPOITABLE_INFO))
					continue
				expanded_examine_more += "<a href='?src=[REF(src)];exploitable_info=1'>\[Exploitable Info\]</a>"
				break
		// Medhuds can see medical records.
		if(client.prefs.medical_records && HAS_TRAIT(hud_wearer, TRAIT_MEDICAL_HUD) && access && (ACCESS_MEDICAL in access))
			expanded_examine_more += "<a href='?src=[REF(src)];medical_records=1'>\[Past Medical Records\]</a>"
		// Sechuds can see security records.
		if(client.prefs.security_records && HAS_TRAIT(hud_wearer, TRAIT_SECURITY_HUD) && access && (ACCESS_SECURITY in access))
			expanded_examine_more += "<a href='?src=[REF(src)];security_records=1'>\[Past Security Records\]</a>"

	expanded_examine_more += "</span>"

	return ..() + expanded_examine_more

/* Determine if the current mob's real identity is visible.
 * There's gotta be a helper proc for this somewhere in the code, right?
 *
 * returns TRUE if we can see their face or if they're wearing their ID so their name shows.
 * returns FALSE otherwise.
 *
 * This means disguising as someone with flavor text won't show it on examine giving the disguise away.
 * This can be fixed or adjusted in the future.
 */
/mob/living/carbon/human/proc/identity_visible()
	// whether their face is covered
	var/face_obscured = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if(!face_obscured)
		return TRUE

	// whether their shown name is their real name
	var/shown_name = trim(get_visible_name(), length(real_name)+1)
	if(shown_name == real_name)
		return TRUE

	return FALSE

#undef ADDITIONAL_INFO_RECORDS
#undef ADDITIONAL_INFO_EXPLOITABLE
#undef ADDITIONAL_INFO_FLAVOR
