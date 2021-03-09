// Good quirks.

// Rebalance existing quirks
/datum/quirk/jolly //haha
	value = 3

/// Trilingual
/datum/quirk/trilingual
	name = "Language - Trilingual"
	desc = "You're trilingual - you know another random language besides common and your native tongue."
	value = 1
	gain_text = "<span class='notice'>You understand a new language.</span>"
	lose_text = "<span class='notice'>You no longer understand a new language.</span>"
	medical_record_text = "Patient is trilingual and knows multiple languages."
	var/datum/language/added_language

/datum/quirk/trilingual/on_spawn()
	var/datum/language_holder/quirk_holder_languages = quirk_holder.get_language_holder()
	if(!added_language)
		added_language = pick(GLOB.all_languages)
		var/attempts = 1
		while(quirk_holder_languages.has_language(added_language))
			added_language = pick(GLOB.all_languages)
			attempts++
			if(attempts > GLOB.all_languages.len)
				stack_trace("Trilingual quirk ([name] - [type]) did not find a language to add.")
				added_language = null
				return

	quirk_holder_languages.grant_language(added_language, TRUE, TRUE, LANGUAGE_QUIRK)

/datum/quirk/trilingual/post_add()
	if(!added_language)
		to_chat(quirk_holder, "<span class='danger'>Your quirk [name] is not compatible with your species or job for one reason or another.</span>")
		return

	var/datum/language/added_language_instance = new added_language
	var/mob/living/carbon/human/human_quirk_holder = quirk_holder
	if(human_quirk_holder.dna?.species?.species_language_holder)
		var/datum/language_holder/species_languages = new human_quirk_holder.dna.species.species_language_holder
		if(species_languages.has_language(added_language, FALSE))
			to_chat(quirk_holder, "<span class='info'>Thanks to your past or species, you can now speak [added_language_instance.name]. You already could understand it, but now you can speak it.</span>")
		else if(species_languages.has_language(added_language, TRUE))
			to_chat(quirk_holder, "<span class='info'>Thanks to your past or species, you can now speak [added_language_instance.name]. You already could speak it, but now you can double speak it. I guess.</span>")
		else
			to_chat(quirk_holder, "<span class='info'>Thanks to your past or species, you know [added_language_instance.name]. It's not guaranteed you can speak it properly, but at least you can understand it.</span>")
		qdel(species_languages)
	qdel(added_language_instance)

/datum/quirk/trilingual/remove()
	var/datum/language_holder/quirk_holder_languages = quirk_holder.get_language_holder()
	quirk_holder_languages.remove_language(added_language, TRUE, TRUE, LANGUAGE_QUIRK)

/datum/quirk/trilingual/high_draconic
	name = "Language - High Draconic"
	desc = "You're trilingual - you know old High Draconic. (This quirk only works for species that can speak draconic!)"
	value = 1
	gain_text = "<span class='notice'>You understand High Draconic.</span>"
	lose_text = "<span class='notice'>You no longer understand High Draconic.</span>"
	medical_record_text = "Patient is trilingual and knows High Draconic."
	added_language = /datum/language/impdraconic

/datum/quirk/trilingual/high_draconic/on_spawn()
	var/datum/language_holder/quirk_holder_languages = quirk_holder.get_language_holder()
	if(!quirk_holder_languages.has_language(/datum/language/draconic, TRUE))
		added_language = null
		return
	. = ..()
