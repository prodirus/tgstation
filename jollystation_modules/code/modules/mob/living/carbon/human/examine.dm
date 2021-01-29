/// Extension of /mob/living/carbon/human/examine().

/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(!client && last_connection_time)
		. += "<span class='info'><i>[p_theyve(TRUE)] been unresponsive for [round((world.time - last_connection_time) / (60*60), 0.1)] minute(s).\n</i>*---------*</span>\n"
