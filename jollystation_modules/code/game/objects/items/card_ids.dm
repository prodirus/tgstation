/// -- ID card extension and additions. --
/obj/item/card/id
	var/alt_icon = 'jollystation_modules/icons/obj/card.dmi'

/obj/item/card/id/update_overlays()
	if(assignment in get_all_module_jobs())
		icon = alt_icon
	else
		icon = initial(icon)

	. = ..()
