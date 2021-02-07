/// Crates and crates galore!

/obj/structure/closet/crate/resource_cache
	name = "resource cache"
	desc = "A steel crate filled to the brim with resources."
	/// Assoc list of resources to amounts
	var/list/obj/item/stack/resources = list()
	/// Whether bonus mats will get added to the crate on spawn.
	var/bonus_mats = TRUE

/obj/structure/closet/crate/resource_cache/PopulateContents()
	. = ..()
	// Add in our resources from the assoc list of resources
	resources = string_assoc_list(resources)
	for(var/contents in resources)
		var/amount = resources[contents]
		new contents(src, amount)

	// A chance to add in some extra metal or glass
	if(bonus_mats)
		switch(rand(1, 200))
			if(1 to 9)
				new /obj/item/stack/sheet/metal(src, 10)
			if(10 to 24)
				new /obj/item/stack/sheet/metal(src, 25)
			if(15 to 34)
				new /obj/item/stack/sheet/glass(src, 10)
			if(35 to 49)
				new /obj/item/stack/sheet/glass(src, 25)
			if(50 to 59)
				new /obj/item/stack/sheet/mineral/gold(src, 8)
			if(60 to 69)
				new /obj/item/stack/sheet/mineral/silver(src, 12)

/// Special crates are rarer and can have rare materials
/obj/structure/closet/crate/resource_cache/special
	icon_state = "securecrate"
	desc = "A steel crate filled to the brim with resources. This one isn't from the syndicate or nanotrasen."

/// Syndicate crates can have syndie contraband hidden away
/obj/structure/closet/crate/resource_cache/syndicate
	icon_state = "secgearcrate"
	desc = "A steel crate filled to the brim with resources. This one is from the syndicate."
	// The max amount of TC we can spend hidden contraband
	var/contraband_value = 8

/obj/structure/closet/crate/resource_cache/syndicate/PopulateContents()
	. = ..()
	if(bonus_mats && prob(4))
		contraband_value += rand(-4, 4)
		var/list/uplink_items = get_uplink_items(SSticker.mode)
		while(contraband_value)
			var/category = pick(uplink_items)
			var/item = pick(uplink_items[category])
			var/datum/uplink_item/I = uplink_items[category][item]
			if(!I.surplus || prob(100 - I.surplus))
				continue
			new I.item(src)

/obj/structure/closet/crate/resource_cache/centcom
	icon_state = "plasmacrate"
	desc = "A steel crate filled to the brim with resources. This one is from centcom."

/obj/structure/closet/crate/resource_cache/normal

/// Basic building mats (metal and glass)
//---
/obj/structure/closet/crate/resource_cache/normal/metals
	icon_state = "engi_crate"
	resources = list(/obj/item/stack/sheet/metal = 50, \
					/obj/item/stack/sheet/glass = 50)

/obj/structure/closet/crate/resource_cache/normal/metals/low
	resources = list(/obj/item/stack/sheet/metal = 30, \
					/obj/item/stack/sheet/glass = 25)

/obj/structure/closet/crate/resource_cache/normal/metals/high
	resources = list(/obj/item/stack/sheet/metal = 120, \
					/obj/item/stack/sheet/glass = 100)
//---

/// Rare metals (silver and gold)
//---
/obj/structure/closet/crate/resource_cache/normal/rare_metals
	icon_state = "engi_secure_crate"
	resources = list(/obj/item/stack/sheet/mineral/gold = 20, \
					/obj/item/stack/sheet/mineral/silver = 25, \
					/obj/item/stack/sheet/mineral/titanium = 30 )

/obj/structure/closet/crate/resource_cache/normal/rare_metals/low
	resources = list(/obj/item/stack/sheet/mineral/gold = 10, \
					/obj/item/stack/sheet/mineral/silver = 12, \
					/obj/item/stack/sheet/mineral/titanium = 20 )

/obj/structure/closet/crate/resource_cache/normal/rare_metals/high
	resources = list(/obj/item/stack/sheet/mineral/gold = 30, \
					/obj/item/stack/sheet/mineral/silver = 40, \
					/obj/item/stack/sheet/mineral/titanium = 50 )
//---

/// Rare gems (diamonds, bluespace crystals)
//---
/obj/structure/closet/crate/resource_cache/normal/rare_gems
	icon_state = "engi_secure_crate"
	resources = list(/obj/item/stack/sheet/mineral/diamond = 10, \
					/obj/item/stack/sheet/bluespace_crystal = 8)

/obj/structure/closet/crate/resource_cache/normal/rare_gems/low
	resources = list(/obj/item/stack/sheet/mineral/diamond = 6, \
					/obj/item/stack/sheet/bluespace_crystal = 5)

/obj/structure/closet/crate/resource_cache/normal/rare_gems/high
	resources = list(/obj/item/stack/sheet/mineral/diamond = 12, \
					/obj/item/stack/sheet/bluespace_crystal = 10)
//---

/// Hazardous resources (plasma and uranium)
//---
/obj/structure/closet/crate/resource_cache/normal/hazardous_metals
	icon_state = "radiation"
	resources = list(/obj/item/stack/sheet/mineral/uranium = 15, \
					/obj/item/stack/sheet/mineral/plasma = 30)

/obj/structure/closet/crate/resource_cache/normal/hazardous_metals/low
	resources = list(/obj/item/stack/sheet/mineral/uranium = 5, \
					/obj/item/stack/sheet/mineral/plasma = 15)

/obj/structure/closet/crate/resource_cache/normal/hazardous_metals/high
	resources = list(/obj/item/stack/sheet/mineral/uranium = 20, \
					/obj/item/stack/sheet/mineral/plasma = 40)
//---

/// Basic materials (cardboard, metal, plastic, wood, glass)
//---
/obj/structure/closet/crate/resource_cache/normal/basic_materials
	resources = list(/obj/item/stack/sheet/cardboard = 20, \
					/obj/item/stack/sheet/metal = 80, \
					/obj/item/stack/sheet/glass = 25)

/obj/structure/closet/crate/resource_cache/normal/poor_materials
	resources = list(/obj/item/stack/sheet/cardboard = 80, \
					/obj/item/stack/sheet/mineral/wood = 50, \
					/obj/item/stack/sheet/plastic = 20, \
					/obj/item/stack/sheet/metal = 30)
//---

/// Weird crates (Random stuff)
//---
/obj/structure/closet/crate/resource_cache/special/weird_materials_cult
	icon_state = "weaponcrate"
	resources = list(/obj/item/stack/sheet/runed_metal = 20, \
					/obj/item/stack/sheet/metal = 30, \
					/obj/item/stack/sheet/glass = 30)

/obj/structure/closet/crate/resource_cache/special/weird_materials_aliens
	icon_state = "weaponcrate"
	resources = list(/obj/item/stack/sheet/mineral/abductor = 25, \
					/obj/item/stack/sheet/metal = 30, \
					/obj/item/stack/sheet/glass = 30)

/obj/structure/closet/crate/resource_cache/special/many_metals
	bonus_mats = FALSE
	resources = list(/obj/item/stack/sheet/metal = 30, \
					/obj/item/stack/sheet/glass = 25, \
					/obj/item/stack/sheet/mineral/gold = 10, \
					/obj/item/stack/sheet/mineral/silver = 12, \
					/obj/item/stack/sheet/mineral/titanium = 15 )

/obj/structure/closet/crate/resource_cache/special/many_rare_mats
	bonus_mats = FALSE
	resources = list(/obj/item/stack/sheet/mineral/gold = 12, \
					/obj/item/stack/sheet/mineral/silver = 12, \
					/obj/item/stack/sheet/mineral/titanium = 10, \
					/obj/item/stack/sheet/mineral/uranium = 10, \
					/obj/item/stack/sheet/mineral/plasma = 15)

/obj/structure/closet/crate/resource_cache/special/diamonds
	bonus_mats = FALSE
	resources = list(/obj/item/stack/sheet/mineral/diamond = 12)

/obj/structure/closet/crate/resource_cache/special/bananium
	bonus_mats = FALSE
	resources = list(/obj/item/stack/sheet/mineral/bananium = 10)

/obj/structure/closet/crate/resource_cache/lizard_things
	name = "\improper lizard empire trade goods"
	desc = "A rough hide crate. This one was made by the Lizard Empire, and contains various trade goods of their people."
	icon_state = "necrocrate"
	resources = list(/obj/item/stack/sheet/sinew = 5, \
					/obj/item/stack/sheet/animalhide/goliath_hide = 5, \
					/obj/item/stack/sheet/bone = 10)

/obj/structure/closet/crate/resource_cache/magic_things
	name = "\improper crate of insquisition contraband"
	desc = "A coarse wooden crate, with a broken seal of thick wax over the lid. Maybe opening this is a bad idea?"
	icon_state = "wooden"
	bonus_mats = FALSE
	resources = list(/obj/item/stack/sheet/mineral/mythril = 2, \
					/obj/item/stack/sheet/mineral/adamantine = 4, \
					/obj/item/stack/sheet/hauntium = 6, \
					/obj/item/stack/sheet/mineral/runite = 12, \
					/obj/item/stack/sheet/runed_metal = 20 )

// Yes, this crate can have literally any stack item.
// No, it's blacklisted from the events that use it for a reason.
/obj/structure/closet/crate/resource_cache/random_materials
	desc = "A steel crate. This one seems like trouble."

/obj/structure/closet/crate/resource_cache/random_materials/Initialize()
	for(var/i in 1 to rand(2, 4))
		resources += list(pick(subtypesof(/obj/item/stack)) = round(rand(1, 50),5))
	. = ..()

//---

/// Syndie stuff (Random stuff)
//---
/obj/structure/closet/crate/resource_cache/syndicate/building_mats
	resources = list(/obj/item/stack/sheet/mineral/plastitanium = 50, \
					/obj/item/stack/sheet/plastitaniumglass = 30)
//---

/// Centcom stuff (Random stuff)
//---
/obj/structure/closet/crate/resource_cache/centcom/building_mats
	resources = list(/datum/material/alloy/plasteel = 50, \
					/obj/item/stack/sheet/plasmarglass = 30)
//---
