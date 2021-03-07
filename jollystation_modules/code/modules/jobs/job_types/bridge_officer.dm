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

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC
	bounty_types = CIV_JOB_RANDOM

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_BRIDGE_OFFICER

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law, /obj/item/storage/fancy)

/datum/outfit/job/bo
	name = "Bridge Officer"
	jobtype = /datum/job/bo

	id = /obj/item/card/id/advanced/silver
	belt = /obj/item/pda/heads/hos
	ears = /obj/item/radio/headset/heads/bo/alt
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/civilian/bo/black
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/armor/vest
	id_trim = /datum/id_trim/job/bridge_officer

	implants = list(/obj/item/implant/mindshield)

	backpack_contents = list(
		/obj/item/melee/classic_baton/telescopic=1, /obj/item/gun/energy/disabler=1)

