/datum/job/bo
	title = "Bridge Officer"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list("Captain")
	head_announce = list(RADIO_CHANNEL_COMMAND)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the heads of staff and the captain"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SERVICE

	outfit = /datum/outfit/job/bo
	plasmaman_outfit = /datum/outfit/plasmaman/head_of_security

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC
	bounty_types = CIV_JOB_RANDOM

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_BRIDGE_OFFICER

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law)

/datum/outfit/job/bo
	name = "Bridge Officer"
	jobtype = /datum/job/bo

	id = /obj/item/card/id/advanced/silver
	belt = /obj/item/pda/heads/hos
	ears = /obj/item/radio/headset/heads/bo/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/security/bridge_officer/black
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/beret/black
	suit = /obj/item/clothing/suit/armor/vest/blueshirt
	suit_store = /obj/item/gun/energy/disabler
	id_trim = /datum/id_trim/job/bridge_officer

	implants = list(/obj/item/implant/mindshield)

	backpack_contents = list(/obj/item/melee/classic_baton/telescopic = 1, /obj/item/modular_computer/tablet/preset/advanced/command = 1)

/datum/outfit/job/bo/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(0.1))
		r_pocket = /obj/item/assembly/flash/memorizer
