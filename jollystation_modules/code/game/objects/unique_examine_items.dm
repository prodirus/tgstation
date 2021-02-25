/// Job defines
#define SECURITY_JOBS_PLUS_CAP GLOB.security_positions + "Captain"
/// Faction defines
#define HERETIC_FACTIONS list("heretics")
#define WIZARD_FACTIONS list(ROLE_WIZARD)

// SYNDICATE / SYNDICATE TOY ITEMS //

/obj/item/storage/backpack/duffelbag/syndie
	name = "duffel bag"
	desc = "A large lightweight duffel bag for holding extra supplies."

/obj/item/storage/backpack/duffelbag/syndie/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "This bag is used to store tactical equipment and is manufactured by Donk Co. It's faster and lighter than other duffelbags without sacrificing any space.", EXAMINE_CHECK_SYNDICATE, hint = FALSE)
	AddElement(/datum/element/unique_examine, "A large, dark colored dufflebag commonly used to transport ammunition, tools, and explosives. Its design makes it much lighter than other duffelbags without sacrificing any space.", EXAMINE_CHECK_JOB, SECURITY_JOBS_PLUS_CAP)

/obj/item/clothing/under/syndicate
	name = "suspicious turtleneck"
	var/unique_description = "A tactical, armored turtleneck manufactured by 'neutral' parties, close to the Gorlex Marauders."

/obj/item/clothing/under/syndicate/Initialize()
	. = ..()
	if(unique_description)
		AddElement(/datum/element/unique_examine, unique_description, EXAMINE_CHECK_SYNDICATE, hint = FALSE)
		AddElement(/datum/element/unique_examine, "A padded, armored outfit commonly used by syndicate operatives in the field.", EXAMINE_CHECK_JOB, SECURITY_JOBS_PLUS_CAP)

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
		AddElement(/datum/element/unique_examine, tacticool_description, EXAMINE_CHECK_SYNDICATE, is_toy = TRUE)

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

// DRINKS //

/obj/item/reagent_containers/food/drinks/bottle/lizardwine/Initialize()
	. = ..()
	var/vintage = rand(GLOB.year_integer + 450, GLOB.year_integer + 540) // Wine has an actual vintage var but lizardwine is special
	AddElement(/datum/element/unique_examine, "A bottle of ethically questionable lizard wine. Rare now-a-days following the harsh regulations placed on the great wine industry. You'd place the vintage at... [(vintage >= 3000) ? "[vintage] Nanotrasen White-Green. Not my personal preference..." : "a respectable [vintage] Nanotrasen White-Green. Wonderful."]", EXAMINE_CHECK_SKILLCHIP, list(/obj/item/skillchip/wine_taster), hint = FALSE)
	AddElement(/datum/element/unique_examine, "A lizardperson's tail is important in keeping balance and warding off enemies in combat situations. You can't help but feel disappointed and saddened looking at this, knowing a fellow kin was robbed of such a thing.", EXAMINE_CHECK_SPECIES, list(/datum/species/lizard))

/obj/item/reagent_containers/food/drinks/bottle/wine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/unique_examine, "A bottle of fine [name]. Classic, refreshing, usually comes with a sharp taste. The vintage is labeled as [generate_vintage()]... You'll be the one to determine that.", EXAMINE_CHECK_SKILLCHIP, list(/obj/item/skillchip/wine_taster), hint = FALSE)

// MAGICAL ITEMS //

/obj/item/scrying
	desc = "A mysterious glowing incandescent orb of crackling energy. Moving your fingers towards it creates arcs of blue electricity."

/obj/item/scrying/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A scrying orb - a view into another plane of existance. Using it will allow you to release your ghost while alive, allowing you to spy upon the station and talk to the deceased. In addition, holding it it will permanently grant you X-ray vision.", EXAMINE_CHECK_FACTION, WIZARD_FACTIONS)

/obj/item/forbidden_book
	name = "suspicious purple book"
	desc = "A purple book clasped with a heavy iron lock and bound in a firm leather."

/obj/item/forbidden_book/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "The Codex Cicatrix - the book of knowledge holding all the secrets of the veil between the worlds, the Mansus. \
											Discovered by Wizard Federation aeons ago but locked away deep in the shelving of the highest security libraries of the Spindward Galaxy, \
											the book was recently stolen during a raid by the Cybersun Industries, copied, and widespread to aspiring seekers of power.", EXAMINE_CHECK_FACTION, HERETIC_FACTIONS)
/obj/item/toy/eldritch_book
	name = "suspicious purple book"

/obj/item/toy/eldritch_book/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A fake Codex Cicatrix - the book of knowledge holding all the secrets of the veil between the worlds, the Mansus. \
											While the book was recently discovered, copied, and spread due to a recent Cybersun Industries raid on a high-security library, \
											it seems as if Nanotrasen has already began marketing and selling fake toy copies for children... interesting.", EXAMINE_CHECK_FACTION, HERETIC_FACTIONS, is_toy = TRUE)

// GUNS //

/obj/item/gun/ballistic/revolver/mateba/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A refitted revolver that takes .357 caliber, the Mateba Model 6 Unica - or as it's commonly known shorthand, either the Mateba or the Unica - has been the weapon of choice for Nanotrasen commanding officers in the field for decades.", EXAMINE_CHECK_MINDSHIELD)

/obj/item/gun/energy/laser/captain/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "The pride and joy of every captain in the Spinward. It's tradition amongst captains to mod and maintain a lasergun of your own, only bringing it out to use in dire straits. \
											Every captain has their own personal modifications - this one is modified with a self-recharging cell and hellfire laser rounds.", EXAMINE_CHECK_JOB, list("Captain"))

/obj/item/gun/energy/e_gun/hos/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A modernized and remastered version of the captain's antique laser gun, the X-01 multiphase energy gun was developed in the past few decades to issue to only the highest brass officers \
											in Nanotrasen security forces. While in the past the gun was outfitted with taser electrodes instead of an ion bolts, it is still used by lead officers for quick response and utility in the event of varying threats.", EXAMINE_CHECK_JOB, GLOB.security_positions)

// HIGH RISK ITEMS //

/obj/item/disk/nuclear/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "Every Nanotrasen operated station comes with an installed self-destruct terminal for extreme measures, and [station_name()] is no exception. \
											The Nuclear Authentication Disk, entrusted only into the hands of the captain, acting captain, or any higher ranked Nanotrasen personel on board the station, \
											is the linch pin of this self-destruct device, providing the only key to activate it - should the holder also have the authentication codes.", EXAMINE_CHECK_MINDSHIELD)
	AddElement(/datum/element/unique_examine, "Only one person is entrusted with the Nuclear Authentication Disk on board the station - the captain (or acting captain in their absence). \
											Being the direct line of communication to Nanotrasen, they are the only member of the crew authorized to hold the authentication disk and (should the situation call for it) enter the codes to the self-destruct. \
											Of course, because of the importance of the disk in unlocking nuclear devices, the Nuclear Authentication Disk is a very sought after object - luckily, it's in good hands...", EXAMINE_CHECK_SKILLCHIP, list(/obj/item/skillchip/disk_verifier), hint = FALSE)

/obj/item/clothing/shoes/magboots/advance/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "The Chief Engineer's treasured advanced magboots - a sleek white design of the standard magboots designed with speed and wearability in mind during extravehicular activity. \
												Offers a lighter magnetic pull compared to standard model of magboots, reducing slowdown without sacrificing safety or usability.", EXAMINE_CHECK_JOB, GLOB.engineering_positions)

/obj/item/clothing/suit/space/hardsuit/engine/elite/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "The Chief Engineer's spotless advanced hardsuit - a sleek white design of the standard engineering and atmospheric hardsuits with improved resistance to fire and radiation.", EXAMINE_CHECK_JOB, GLOB.engineering_positions)

/obj/item/card/id/captains_spare/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "The captain's spare ID card - the backup all-access ID card assigned to the care of the captain themselves. Standard-issue golden ID cards supplied to all Nanotrasen operated space stations, to allow \
											for normal operation of every aspect of the station in the absence of the captain... assuming it doesn't end up in the hands of certain gas-masked individuals, of course.", EXAMINE_CHECK_JOB, list("Captain", "Head of Personnel"))

/obj/item/hand_tele/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "The Hand Teleporter, a breakthrough of bluespace technology, is a miniature hand-held version of the larger room-sized teleporters found aboard various stations across the Spinward. \
										While not as powerful independently as a full teleporter gate setup just yet, these are often entrusted to the Captain for their emergencies, though Research Directors and even space explorers are often given one for personal usage.", EXAMINE_CHECK_JOB, list("Captain", "Research Director", "Scientist"))

// MOBS //

/mob/living/simple_animal/pet/dog/corgi/ian/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "It's Ian! Your trusty companion through and through. It's the Head of Personnel's secondary job to keep Ian safe and sound from anything that can harm them. Ian's birthday is on September 9th - be sure to celebrate!", EXAMINE_CHECK_JOB, list("Head of Personnel"))

/mob/living/carbon/alien/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A xenomorph - an alien species designed to hunt and capture live prey. They reproduce by attaching facehuggers to their prey, impregnating them with the alient seed, eventually causing the host to burst in a violent display of gore as a new larva writhes out.", EXAMINE_CHECK_JOB, list("Research Director", "Scientist", "Xenobiologist"))
	AddElement(/datum/element/unique_examine, "A xenomorph - an alien species designed to hunt live prey. Weak to flames and laser fire. Facial coverage in the form of biosuits, hardsuits, or riot helmets are of utmost importance when facing these creatures to avoid being 'facehugged' by their offspring.", EXAMINE_CHECK_JOB, SECURITY_JOBS_PLUS_CAP, hint = FALSE)

/mob/living/simple_animal/hostile/alien/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A xenomorph - an alien species designed to hunt and capture live prey. They reproduce by attaching facehuggers to their prey, impregnating them with the alient seed, eventually causing the host to burst in a violent display of gore as a new larva writhes out.", EXAMINE_CHECK_JOB, list("Research Director", "Scientist", "Xenobiologist"))
	AddElement(/datum/element/unique_examine, "A xenomorph - an alien species designed to hunt live prey. Weak to flames and laser fire. Facial coverage in the form of biosuits, hardsuits, or riot helmets are of utmost importance when facing these creatures to avoid being 'facehugged' by their offspring.", EXAMINE_CHECK_JOB, SECURITY_JOBS_PLUS_CAP, hint = FALSE)

/mob/living/carbon/alien/humanoid/royal/queen/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A xenomorph queen - the patriarch of the xenomorph species. Produces large, brown eggs which birth into the facehugger - the small, jumpy alien creature responisble for the alien's method of reproduction. Leads its sisters and offspring through their alien hivemind - when slain, releases a psychic screen via the hivemind, greatly disorienting their kin.", EXAMINE_CHECK_JOB, list("Research Director", "Scientist", "Xenobiologist"), hint = FALSE)
	AddElement(/datum/element/unique_examine, "A xenomorph queen - the patriarch of the xenomorph species. Leads the nest through their xenomorph hivemind. The source of the xenos - killing the queen is important in killing the hive. When slain, releases a psychic scream along the alien hivemind, confusing and disorienting their kin and offspring.", EXAMINE_CHECK_JOB, SECURITY_JOBS_PLUS_CAP, hint = FALSE)

/mob/living/simple_animal/hostile/alien/queen/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A xenomorph queen - the patriarch of the xenomorph species. Produces large, brown eggs which birth into the facehugger - the small, jumpy alien creature responisble for the alien's method of reproduction. Leads its sisters and offspring through their alien hivemind - when slain, releases a psychic screen via the hivemind, greatly disorienting their kin.", EXAMINE_CHECK_JOB, list("Research Director", "Scientist", "Xenobiologist"), hint = FALSE)
	AddElement(/datum/element/unique_examine, "A xenomorph queen - the patriarch of the xenomorph species. Leads the nest through their xenomorph hivemind. The source of the xeno menace - killing the queen is crucial in killing the hive. When slain, releases a psychic scream along the alien hivemind, confusing and disorienting their kin and offspring.", EXAMINE_CHECK_JOB, SECURITY_JOBS_PLUS_CAP, hint = FALSE)

// MACHINES //

/obj/machinery/computer/communications/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "The communications console is the station's one and only link to central command for anything and everything. If every console on the station is destoyed, the emergency shuttle is automatically called on a 25 minute timer. \
												Likewise if a large percentage of the station's crew perish the shuttle is automatically called in that case, too. It's good that central command cares.", EXAMINE_CHECK_JOB, list("Captain", "Head of Personnel", "Bridge Officer"))

/obj/machinery/power/supermatter_crystal/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "Hope you're wearing meson goggles - Crystallized supermatter, one of the most deadly and reactive things in the universe. Supermatter reacts when shot with energy, turning the light energy of emitters into heated waste gases and bursts of gamma radiation.", EXAMINE_CHECK_JOB, GLOB.engineering_positions)

/obj/machinery/computer/slot_machine/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "Often called 'one armed bandit', 'fruit machine', or just 'slots', \the [src] is one of the most common forms of gambling in the galaxy. A 7 century old design. Simple and addictive - Hopefully you're doing your job and not playing it right now.", EXAMINE_CHECK_JOB, GLOB.service_positions)


// STRUCTURES //

/obj/structure/altar_of_gods/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "This religious altar is the place where chaplains can commune with their deities and undergo mystical rituals to their gods. The closest place on the station to the gods above is in front of the altar, and it's where the most successful prayers and rituals take place.", EXAMINE_CHECK_TRAIT, list(TRAIT_SPIRITUAL))

/obj/effect/eldritch/big/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "The transumation circle - the site to most known rituals involving unlocking the key to the veil between worlds. Many concentric black ink circles are drawn \
											amidst a larger, thick green circle, weakening the chains of reality and allowing a seekers of ancient powers to access the mysteries of the Mansus.", EXAMINE_CHECK_FACTION, HERETIC_FACTIONS)

#define HERETIC_REALITY_MESSAGES list("THE HIGHER I RISE, THE MORE I SEE.", \
									"THE VEIL IS SHATTERED.", \
									"THE GATES OF THE MANSUS IS HERE, IS OPEN.", \
									"I AM BEING WATCHED... FROM WHERE? FROM WHAT?", \
									"A SHIMMER... POTENTIAL... POWER.", \
									"THEIR HAND IS AT MY SIDE.", \
									"STRENGTH... UNPARALLELED. UNNATURAL.", \
									"I AM LATE FOR MY DESTINY.", \
									"TO WALK BETWEEN PLANES.", \
									"THEY WALK THE WORLD. UNNOTICED.", \
									"CURSED LAND, CURSED MAN, CURSED MIND.", \
									"GREATER HEIGHTS.", \
									"SCREAMS. SILENCE.", \
									"RAIN OF BLOOD. REIGN OF BLOOD.", \
									"LIFE IS FLEETING, BUT WHAT YET STAYS?", \
									"COVERED AND FORGOTTEN.", \
									"A WHISPER.")

/obj/effect/reality_smash/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A pierce in reality - a weakness in the veil that allows power to be gleamed from the Mansus.\n<span class='hypnophrase'>[pick(HERETIC_REALITY_MESSAGES)]</span>", EXAMINE_CHECK_FACTION, HERETIC_FACTIONS)

/obj/effect/broken_illusion/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A tapped pierce in reality - this one has been sapped of power. There is nothing here for Them any longer.\n<span class='hypnophrase'>[pick(HERETIC_REALITY_MESSAGES)]</span>", EXAMINE_CHECK_FACTION, HERETIC_FACTIONS)
	AddElement(/datum/element/unique_examine, "<span class='big hypnophrase'>A harrowing reminder of the fragility of our reality, the fleeting nature of life, and of impending slow doom.</span>", EXAMINE_CHECK_NONE, hint = FALSE)
	AddElement(/datum/element/unique_examine, "A tapped, used rift in reality. Its pressence means a fellow mortal - likely a crewmate - desired to attempt to throw off the shackles of reality and went off seeking power and strength from a copy of the forbidden Codex Cicatrix.", EXAMINE_CHECK_MINDSHIELD, hint = FALSE)

/obj/item/toy/reality_pierce/Initialize()
	. = ..()
	AddElement(/datum/element/unique_examine, "A pierced reality - a weakness in the veil that allows power to be gleamed from the Mansus. This one is fake, however. How'd they even make this?", EXAMINE_CHECK_FACTION, HERETIC_FACTIONS)

#undef SECURITY_JOBS_PLUS_CAP
#undef HERETIC_FACTIONS
#undef WIZARD_FACTIONS

#undef HERETIC_REALITY_MESSAGES
