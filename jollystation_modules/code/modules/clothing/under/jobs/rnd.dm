/obj/item/clothing/under/rank/rn
	icon = 'jollystation_modules/icons/obj/clothing/under/rnd.dmi'
	worn_icon = 'jollystation_modules/icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rn/toxicologist
	desc = "It's made of a special fiber that provides minor protection against explosives. It has markings that denote the wearer as a toxicologist."
	name = "toxicologist's jumpsuit"
	icon_state = "toxin"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 15, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/under/rank/rn/toxicologist/skirt
	desc = "It's made of a special fiber that provides minor protection against explosives. It has markings that denote the wearer as a toxicologist."
	name = "toxicologist's jumpsuit"
	icon_state = "toxin_skirt"
	inhand_icon_state = "w_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 15, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/rn/xenobiologist
	desc = "It has markings that denote the wearer as a Xenobiologist."
	name = "xenobiologist's jumpsuit"
	icon_state = "xeno"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5

/obj/item/clothing/under/rank/rn/xenobiologist/skirt
	desc = "It has markings that denote the wearer as a Xenobiologist."
	name = "xenobiologist's jumpsuit"
	icon_state = "xeno_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP
