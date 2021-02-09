//Skyrat SS13 Code Adapted for Jollystation, originally written by Gandalf2k15.
/*
EXTRA EXAMINE MODULE
This is the module for handling items with special examine stats,
like syndicate items having information in their description that
would only be recognisable with someone that had the syndicate trait.
*/

#define SECURITY_JOBS list("Security Officer", "Warden", "Detective", "Head of Security")
#define SECURITY_JOBS_HOS SECURITY_JOBS + "Head of Security"
#define SECURITY_JOBS_HOS_CAP SECURITY_JOBS_HOS + "Captain"
#define SILICON_JOBS list("Cyborg", "AI")

//////////
//Usage://
//////////

//STORAGE//
/obj/item/storage/backpack/duffelbag/syndie
	name = "duffel bag"
	desc = "A large duffel bag for holding extra supplies."

/obj/item/storage/backpack/duffelbag/syndie/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "This bag is used to store tactical equipment and is manufactured by Donk Co. It's faster and lighter than other duffelbags without sacrificing any space.", EXAMINE_CHECK_SYNDICATE)

//UNDER//

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

// DRINKS

/obj/item/reagent_containers/food/drinks/bottle/lizardwine/Initialize()
	. = ..()
	var/vintage = rand(GLOB.year_integer + 450, GLOB.year_integer + 540) // Wine has an actual vintage var but lizardwine is special
	AddElement(/datum/element/unique_examine, "A bottle of ethically questionable lizard wine. Rare now-a-days following the harsh regulations placed on the great wine industry. You'd place the vintage at... [(vintage >= 3000) ? "[vintage] Nanotrasen White-Green. Not my personal preference..." : "a respectable [vintage] Nanotrasen White-Green. Wonderful."]", EXAMINE_CHECK_SKILLCHIP, list(/obj/item/skillchip/wine_taster))
	AddElement(/datum/element/unique_examine, "A lizardperson's tail is important in keeping balance and warding off enemies in combat situations. You can't help but feel disappointed and saddened looking at this, knowing a fellow kin was robbed of such a thing.", EXAMINE_CHECK_SPECIES, list(/datum/species/lizard))

/obj/item/reagent_containers/food/drinks/bottle/wine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/unique_examine, "A bottle of fine [name]. Classic, refreshing, usually comes with a sharp taste. The vintage is labeled as [generate_vintage()]... You'll be the one to determine that.", EXAMINE_CHECK_SKILLCHIP, list(/obj/item/skillchip/wine_taster))

/obj/item/scrying
	desc = "A mysterious glowing incandescent orb of crackling energy. Moving your fingers towards it creates arcs of blue electricity."

/obj/item/scrying/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/unique_examine, "A scrying orb - a view into another plane of existance. Using it will allow you to release your ghost while alive, allowing you to spy upon the station and talk to the deceased. In addition, holding it it will permanently grant you X-ray vision.", EXAMINE_CHECK_FACTION, list(ROLE_WIZARD))

#undef SECURITY_JOBS
#undef SECURITY_JOBS_CAP
#undef SECURITY_JOBS_HOS_CAP
#undef SILICON_JOBS
