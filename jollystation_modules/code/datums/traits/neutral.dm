/datum/quirk/size_change
	name = "Size - Average Height"
	desc = "You are average. (0% size change.)"
	value = 0
	gain_text = "<span class='notice'>You feel average.</span>"
	lose_text = "<span class='notice'>You still feel average.</span>"
	medical_record_text = "Patient is of average height."
	//The amount we resize the quirk holder for.
	var/resize_amount = 1

/datum/quirk/size_change/add()
	if(resize_amount > 1)
		ADD_TRAIT(quirk_holder, TRAIT_GIANT, ROUNDSTART_TRAIT)
	else if(resize_amount < 1)
		ADD_TRAIT(quirk_holder, TRAIT_DWARF, ROUNDSTART_TRAIT)

	quirk_holder.resize = resize_amount
	quirk_holder.update_transform()

/datum/quirk/size_change/remove()
	if(resize_amount > 1)
		REMOVE_TRAIT(quirk_holder, TRAIT_GIANT, ROUNDSTART_TRAIT)
	else if(resize_amount < 1)
		REMOVE_TRAIT(quirk_holder, TRAIT_DWARF, ROUNDSTART_TRAIT)

	quirk_holder.resize = 1/resize_amount
	quirk_holder.update_transform()

/datum/quirk/size_change/vv_large
	name = "Size - Extremely Large"
	desc = "You're massive. (50% larger)"
	gain_text = "<span class='notice'>You feel even more taller.</span>"
	lose_text = "<span class='notice'>You feel even more shorter.</span>"
	medical_record_text = "Patient has extremely un-natural height and size."
	resize_amount = 1.5

/datum/quirk/size_change/v_large
	name = "Size - Very Large"
	desc = "You're huge. (20% larger)"
	gain_text = "<span class='notice'>You feel even taller.</span>"
	lose_text = "<span class='notice'>You feel even shorter.</span>"
	medical_record_text = "Patient has very un-natural height and size."
	resize_amount = 1.2

/datum/quirk/size_change/large
	name = "Size - Large"
	desc = "You're large and in charge. (10% larger)"
	gain_text = "<span class='notice'>You feel taller.</span>"
	lose_text = "<span class='notice'>You feel shorter.</span>"
	medical_record_text = "Patient has un-natural height and size."
	resize_amount = 1.1

/datum/quirk/size_change/short
	name = "Size - Small"
	desc = "You're pretty small. (10% smaller)"
	gain_text = "<span class='notice'>You feel shorter.</span>"
	lose_text = "<span class='notice'>You feel taller.</span>"
	medical_record_text = "Patient is un-naturally short in stature."
	resize_amount = 0.9

/datum/quirk/size_change/v_short
	name = "Size - Very Small"
	desc = "You're VERY small. (20% smaller)"
	gain_text = "<span class='notice'>You feel even shorter.</span>"
	lose_text = "<span class='notice'>You feel even taller.</span>"
	medical_record_text = "Patient is very un-naturally short in stature."
	resize_amount = 0.8

/datum/quirk/size_change/vv_short
	name = "Size - Extremely Small"
	desc = "You're EXTREMELY small. (30% smaller)"
	gain_text = "<span class='notice'>You feel even more shorter.</span>"
	lose_text = "<span class='notice'>You feel even more taller.</span>"
	medical_record_text = "Patient is extremely un-naturally short in stature."
	resize_amount = 0.3
