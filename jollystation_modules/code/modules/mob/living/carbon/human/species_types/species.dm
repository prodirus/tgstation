/// -- Extensions of species and species procs. --
/datum/species
	/// Assoc list of [sounds that play on speech] to [volume].
	var/speech_sounds = list('jollystation_modules/sound/voice/speak_1.ogg' = 100, \
							'jollystation_modules/sound/voice/speak_2.ogg' = 100, \
							'jollystation_modules/sound/voice/speak_3.ogg' = 100, \
							'jollystation_modules/sound/voice/speak_4.ogg' = 100)
	/// Assoc list of [sounds that play on question] to [volume].
	var/speech_sounds_ask = list('jollystation_modules/sound/voice/speak_1_ask.ogg' = 100, \
								'jollystation_modules/sound/voice/speak_2_ask.ogg' = 100, \
								'jollystation_modules/sound/voice/speak_3_ask.ogg' = 100, \
								'jollystation_modules/sound/voice/speak_4_ask.ogg' = 100)
	/// Assoc list of [sounds that play on exclamation] to [volume].
	var/speech_sounds_exclaim = list('jollystation_modules/sound/voice/speak_1_exclaim.ogg' = 100, \
								'jollystation_modules/sound/voice/speak_2_exclaim.ogg' = 100, \
								'jollystation_modules/sound/voice/speak_3_exclaim.ogg' = 100, \
								'jollystation_modules/sound/voice/speak_4_exclaim.ogg' = 100)
	/// Assoc list of [sounds that play on exclamation] to [volume].
	var/speech_sounds_radio = list('jollystation_modules/sound/voice/radio.ogg' = 75, \
								'jollystation_modules/sound/voice/radio_2.ogg' = 75)

/datum/species/on_species_gain(mob/living/carbon/new_mob, datum/species/old_species, pref_load)
	. = ..()
	RegisterSignal(new_mob, COMSIG_MOB_SAY, .proc/handle_speech_sounds)
	RegisterSignal(new_mob, COMSIG_MOVABLE_HEAR, .proc/handle_speech_hearing)

/datum/species/on_species_loss(mob/living/carbon/new_mob, datum/species/old_species, pref_load)
	. = ..()
	UnregisterSignal(new_mob, COMSIG_MOB_SAY)
	UnregisterSignal(new_mob, COMSIG_MOVABLE_HEAR)

/datum/species/proc/handle_speech_sounds(mob/speaker, list/speech_args)
	SIGNAL_HANDLER

	var/msg_end = copytext_char(speech_args[SPEECH_MESSAGE], -1)
	var/list/chosen_speech_sounds = list()
	switch(msg_end)
		if("?")
			chosen_speech_sounds = speech_sounds_ask
		if("!")
			chosen_speech_sounds = speech_sounds_exclaim
		else
			chosen_speech_sounds = speech_sounds

	if(!chosen_speech_sounds.len)
		return

	var/picked_sound = pick(chosen_speech_sounds)
	playsound(speaker, picked_sound, chosen_speech_sounds[picked_sound], vary = TRUE, pressure_affected = TRUE, ignore_walls = FALSE)

/datum/species/proc/handle_speech_hearing(mob/hearer, list/hearing_args)
	SIGNAL_HANDLER

	if(!hearing_args[7][MODE_HEADSET] && !hearing_args[7][RADIO_EXTENSION])
		return

	var/list/chosen_speech_sounds = list('jollystation_modules/sound/voice/radio.ogg' = 75, \
										'jollystation_modules/sound/voice/radio_2.ogg' = 75)
	var/atom/movable/virtualspeaker/speaker = hearing_args[HEARING_SPEAKER]
	if(issilicon(speaker.source))
		chosen_speech_sounds = list('jollystation_modules/sound/voice/radio_ai.ogg' = 75)
	else
		var/mob/living/carbon/human/human_speaker = speaker.source
		if(istype(human_speaker))
			if(human_speaker.dna?.species)
				chosen_speech_sounds = human_speaker.dna.species.speech_sounds_radio

	if(!chosen_speech_sounds.len)
		return

	var/picked_sound = pick(chosen_speech_sounds)
	if(speaker.source == hearer)
		playsound(hearer, picked_sound, chosen_speech_sounds[picked_sound], vary = TRUE, extrarange = -13, ignore_walls = FALSE)
	else
		playsound(hearer, picked_sound, chosen_speech_sounds[picked_sound] - 15, vary = TRUE, extrarange = -15, ignore_walls = FALSE)
