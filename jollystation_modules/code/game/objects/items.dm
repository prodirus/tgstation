/// This file is currently full of examples and usages for of the [Unique examine element][/datum/element/unique_examine]
/// In the future this should probably be split into the proper files and the defines are moved up to the module defines
/// but for now, they sit here.
#define SECURITY_JOBS list("Security Officer", "Warden", "Detective", "Head of Security")
#define SECURITY_JOBS_HOS SECURITY_JOBS + "Head of Security"
#define SECURITY_JOBS_HOS_CAP SECURITY_JOBS_HOS + "Captain"
#define SILICON_JOBS list("Cyborg", "AI")

// SYNDICATE, SYNDICATE TOY, AND JOB EXAMINES //

/obj/item/storage/backpack/duffelbag/syndie
	name = "duffel bag"
	desc = "A large lightweight duffel bag for holding extra supplies."

/obj/item/storage/backpack/duffelbag/syndie/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "This bag is used to store tactical equipment and is manufactured by Donk Co. It's faster and lighter than other duffelbags without sacrificing any space.", EXAMINE_CHECK_SYNDICATE)
	AddElement(/datum/element/unique_examine, "A large, dark colored dufflebag commonly used to transport ammunition, tools, and explosives. Its design makes it much lighter than other duffelbags without sacrificing any space.", EXAMINE_CHECK_JOB, SECURITY_JOBS_HOS_CAP)

/obj/item/clothing/under/syndicate
	name = "suspicious turtleneck"
	var/unique_description = "A tactical, armored turtleneck manufactured by 'neutral' parties, close to the Gorlex Marauders."

/obj/item/clothing/under/syndicate/Initialize()
	. = ..()
	if(unique_description)
		AddElement(/datum/element/unique_examine, unique_description, EXAMINE_CHECK_SYNDICATE)
		AddElement(/datum/element/unique_examine, "A padded, armored outfit commonly used by syndicate operatives in the field.", EXAMINE_CHECK_JOB, SECURITY_JOBS_HOS_CAP)

/obj/item/clothing/under/syndicate/skirt
	name = "suspicious skirtleneck"
	unique_description = "A tactical, armored skirtleneck manufactured by 'neutral' parties, close to the Gorlex Marauders."

/obj/item/clothing/under/syndicate/bloodred
	name = "blood-red pajamas"
	desc = "Pajamas, manufactured in an ominous blood-red color scheme... it feels heavy."
	unique_description = "Developed by Roseus Galactic in conjunction with the Gorlex Marauders, part of the Tactical Sneaksuit bundle. Not space resistant."

/obj/item/clothing/under/syndicate/bloodred/sleepytime
	unique_description = "A Gorlex Marauders staple, through and through - comfy pajamas."

/obj/item/clothing/under/syndicate/tacticool
	unique_description = ""
	var/tacticool_description = "Knockoff, Nanotrasen brand tactical turtleneck - it's not even the right color."

/obj/item/clothing/under/syndicate/tacticool/Initialize()
	. = ..()
	if(tacticool_description)
		AddElement(/datum/element/unique_examine, tacticool_description, EXAMINE_CHECK_SYNDICATE_TOY)

/obj/item/clothing/under/syndicate/tacticool/skirt
	tacticool_description = "Knockoff, Nanotrasen brand tactical skirtleneck - it's not even the right color."

/obj/item/clothing/under/syndicate/sniper
	name = "silk suit"
	desc = "A heavy, comfortable silk suit. The collar is really sharp."
	unique_description = "A double seamed tactical turtleneck disguised as a civilian grade silk suit. Intended for the most formal operator."

/obj/item/clothing/under/syndicate/combat
	unique_description = "Favored by Cybersun operatives for it's 'maintenance camo', this otherwise standard Tactical Turtleneck remains a classic part of the Syndicate."

/obj/item/clothing/under/syndicate/coldres
	name = "insulated suspicious turtleneck"
	desc = "A suspicious looking turtleneck with camouflage cargo pants. It's pretty padded and warm."
	unique_description = "A nondescript and slightly suspicious-looking turtleneck with digital camouflage cargo pants. The interior has been padded with special insulation for both warmth and protection. It's normally assigned to operatives deployed into frozen hellscapes."

/obj/item/clothing/under/syndicate/rus_army
	unique_description = ""

/obj/item/clothing/under/syndicate/camo
	unique_description = ""

/obj/item/clothing/under/syndicate/soviet
	unique_description = ""

// SKILL CHIP & SPECIES EXAMINES //

/obj/item/reagent_containers/food/drinks/bottle/lizardwine/Initialize()
	. = ..()
	var/vintage = rand(GLOB.year_integer + 450, GLOB.year_integer + 540) // Wine has an actual vintage var but lizardwine is special
	AddElement(/datum/element/unique_examine, "A bottle of ethically questionable lizard wine. Rare now-a-days following the harsh regulations placed on the great wine industry. You'd place the vintage at... [(vintage >= 3000) ? "[vintage] Nanotrasen White-Green. Not my personal preference..." : "a respectable [vintage] Nanotrasen White-Green. Wonderful."]", EXAMINE_CHECK_SKILLCHIP, list(/obj/item/skillchip/wine_taster))
	AddElement(/datum/element/unique_examine, "A lizardperson's tail is important in keeping balance and warding off enemies in combat situations. You can't help but feel disappointed and saddened looking at this, knowing a fellow kin was robbed of such a thing.", EXAMINE_CHECK_SPECIES, list(/datum/species/lizard))

/obj/item/reagent_containers/food/drinks/bottle/wine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/unique_examine, "A bottle of fine [name]. Classic, refreshing, usually comes with a sharp taste. The vintage is labeled as [generate_vintage()]... You'll be the one to determine that.", EXAMINE_CHECK_SKILLCHIP, list(/obj/item/skillchip/wine_taster))

// FACTION EXAMINES //

/obj/item/scrying
	desc = "A mysterious glowing incandescent orb of crackling energy. Moving your fingers towards it creates arcs of blue electricity."

/obj/item/scrying/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/unique_examine, "A scrying orb - a view into another plane of existance. Using it will allow you to release your ghost while alive, allowing you to spy upon the station and talk to the deceased. In addition, holding it it will permanently grant you X-ray vision.", EXAMINE_CHECK_FACTION, list(ROLE_WIZARD))

// MINDSHIELD EXAMINES //

/obj/item/gun/ballistic/revolver/mateba/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A refitted revolver that takes .357 caliber, the Mateba Model 6 Unica - or as it's commonly known shorthand, either the Mateba or the Unica - has been the weapon of choice for Nanotrasen commanding officers in the field for decades.", EXAMINE_CHECK_MINDSHIELD)

/obj/item/disk/nuclear/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "Every Nanotrasen operated station comes with an installed self-destruct terminal for extreme measures, and [station_name()] is no exception. \
											The Nuclear Authentication Disk, entrusted only into the hands of the captain, acting captain, or any higher ranked Nanotrasen personel on board the station, \
											is the linch pin of this self-destruct device, providing the only key to activate it - should the holder also have the authentication codes.", EXAMINE_CHECK_MINDSHIELD)
	AddElement(/datum/element/unique_examine, "Only one person is entrusted with the Nuclear Authentication Disk on board the station - the captain (or acting captain in their absence). \
											Being the direct line of communication to Nanotrasen, they are the only member of the crew authorized to hold the authentication disk and (should the situation call for it) enter the codes to the self-destruct. \
											Of course, because of the importance of the disk in unlocking nuclear devices, the Nuclear Authentication Disk is a very sought after object - luckily, it's in good hands...", EXAMINE_CHECK_SKILLCHIP, list(/obj/item/skillchip/disk_verifier))

// MORE JOB EXAMPLES

/obj/item/hand_tele/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "The Hand Teleporter, a breakthrough of bluespace technology, is a miniature hand-held version of the larger room-sized teleporters found aboard various stations across the Spinward. \
										While not as powerful independently as a full teleporter gate setup just yet, these are often entrusted to the Captain for their emergencies, though Research Directors and even space explorers are often given one for personal usage.", EXAMINE_CHECK_JOB, list("Captain", "Research Director", "Scientist"))

/obj/item/gun/energy/laser/captain/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "The pride and joy of every captain in the Spinward. It's tradition amongst captains to mod and maintain a lasergun of your own, only bringing it out to use in dire straits. \
											Every captain has their own personal modifications - this one is modified with a self-recharging cell and hellfire laser rounds.", EXAMINE_CHECK_JOB, list("Captain"))

// ON MOB EXAMPLES

/mob/living/simple_animal/pet/dog/corgi/ian/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "It's Ian! Your trusty companion through and through. It's the Head of Personnel's secondary job to keep Ian safe and sound from anything that can harm them. Ian's birthday is on September 9th - be sure to celebrate!", EXAMINE_CHECK_JOB, list("Head of Personnel"))


#undef SECURITY_JOBS
#undef SECURITY_JOBS_CAP
#undef SECURITY_JOBS_HOS_CAP
#undef SILICON_JOBS
