/// -- mob/living vars and overrides. --
/mob/living
	/// Assoc list of [special speech sounds] to [volume].
	var/special_speech_sounds
	/// Assoc list of [special speech sounds] to [volume].
	var/special_radio_sounds
	/// Assoc list of [sounds that play on exclamation] to [volume].
	var/speech_sounds_radio = list('jollystation_modules/sound/voice/radio.ogg' = 75, \
								'jollystation_modules/sound/voice/radio_2.ogg' = 75)

/mob/living/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	. = ..()

	if(!message)
		return

	var/list/chosen_speech_sounds
	var/mob/living/carbon/human/human_speaker = src
	if(istype(human_speaker) && human_speaker.dna?.species)
		var/msg_end = copytext_char(message, -1)
		switch(msg_end)
			if("?")
				chosen_speech_sounds = human_speaker.dna.species.speech_sounds_ask
			if("!")
				chosen_speech_sounds = human_speaker.dna.species.speech_sounds_exclaim

		// if we didn't get any specific speech sounds, use the default ones
		if(!LAZYLEN(chosen_speech_sounds) && LAZYLEN(human_speaker.dna.species.speech_sounds))
			chosen_speech_sounds = human_speaker.dna.species.speech_sounds

	else if(LAZYLEN(special_speech_sounds))
		chosen_speech_sounds = special_speech_sounds
	if(!LAZYLEN(chosen_speech_sounds))
		return

	var/picked_sound = pick(chosen_speech_sounds)
	playsound(src, picked_sound, chosen_speech_sounds[picked_sound], vary = TRUE, pressure_affected = TRUE, extrarange = -10, ignore_walls = FALSE)

/mob/living/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	. = ..()

	if(!message)
		return

	if(!client)
		return

	if(!message_mods[MODE_HEADSET] && !message_mods[RADIO_EXTENSION])
		return

	var/list/chosen_speech_sounds
	var/atom/movable/virtualspeaker/vspeaker = speaker
	var/mob/living/living_speaker
	if(istype(vspeaker))
		living_speaker = vspeaker.source
		if(!istype(living_speaker))
			return
	else if(isliving(speaker))
		living_speaker = speaker
	else
		return

	if(LAZYLEN(living_speaker.special_radio_sounds))
		chosen_speech_sounds = living_speaker.special_radio_sounds
	else
		chosen_speech_sounds = living_speaker.speech_sounds_radio

	if(!LAZYLEN(chosen_speech_sounds))
		return

	var/picked_sound = pick(chosen_speech_sounds)
	if(speaker == src)
		playsound(src, picked_sound, chosen_speech_sounds[picked_sound], vary = TRUE, extrarange = -13, ignore_walls = FALSE)
	else
		playsound(src, picked_sound, chosen_speech_sounds[picked_sound] - 15, vary = TRUE, extrarange = -15, ignore_walls = FALSE)


// Override prepare_huds() to setup huds with our file instead
// This is a pretty ghetto copy+paste override
/mob/living/prepare_huds()
	prepare_jollystation_huds()
	prepare_data_huds()
