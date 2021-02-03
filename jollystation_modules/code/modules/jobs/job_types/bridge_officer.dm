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

	access = list(
						ACCESS_MEDICAL, ACCESS_PSYCHOLOGY, ACCESS_ENGINE, ACCESS_EVA, ACCESS_HEADS, ACCESS_BRIG, ACCESS_COURT,
						ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
						ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_LAWYER,
						ACCESS_CHAPEL_OFFICE, ACCESS_RESEARCH,
						ACCESS_MECH_ENGINE, ACCESS_MECH_SCIENCE, ACCESS_MECH_MEDICAL, ACCESS_MECH_SECURITY,
						ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_COURT, ACCESS_BRIG,
						ACCESS_MEDICAL, ACCESS_PSYCHOLOGY, ACCESS_ENGINE, ACCESS_EVA, ACCESS_HEADS,
						ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
						ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_LAWYER,
						ACCESS_MECH_ENGINE, ACCESS_MECH_SCIENCE, ACCESS_MECH_SECURITY, ACCESS_MECH_MEDICAL,
						ACCESS_CHAPEL_OFFICE, ACCESS_RESEARCH,
						ACCESS_RC_ANNOUNCE, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC
	bounty_types = CIV_JOB_RANDOM

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_BRIDGE_OFFICER

/datum/outfit/job/bo
	name = "Bridge Officer"
	jobtype = /datum/job/bo

	id = /obj/item/card/id/silver
	belt = /obj/item/pda/heads/hos
	ears = /obj/item/radio/headset/heads/bo/alt
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/civilian/bo/black
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/armor/vest
	backpack_contents = list(
		/obj/item/melee/classic_baton/telescopic=1, /obj/item/gun/energy/disabler=1)

