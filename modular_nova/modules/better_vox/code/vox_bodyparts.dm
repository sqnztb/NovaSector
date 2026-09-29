// voxs!
/obj/item/bodypart/head/mutant/vox_primalis
	icon_static = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_greyscale = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_state = "vox_primalis_head"
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox_primalis
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	limb_id = SPECIES_VOX_PRIMALIS
	eyes_icon = 'modular_nova/modules/better_vox/icons/bodyparts/vox_eyes.dmi'
	teeth_count = 72

/obj/item/bodypart/chest/mutant/vox_primalis
	icon_static = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_greyscale = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_state = "vox_primalis_chest"
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox_primalis
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	limb_id = SPECIES_VOX_PRIMALIS

/obj/item/bodypart/arm/left/mutant/vox_primalis
	icon_static = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_greyscale = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_state = "vox_primalis_l_arm"
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox_primalis
	should_draw_greyscale = FALSE
	limb_id = SPECIES_VOX_PRIMALIS

/obj/item/bodypart/arm/right/mutant/vox_primalis
	icon_static = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_greyscale = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_state = "vox_primalis_r_arm"
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox_primalis
	should_draw_greyscale = FALSE
	limb_id = SPECIES_VOX_PRIMALIS

/obj/item/bodypart/leg/left/mutant/vox_primalis
	icon_static = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_greyscale = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_state = "vox_primalis_l_leg"
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox_primalis
	should_draw_greyscale = FALSE
	limb_id = SPECIES_VOX_PRIMALIS

/obj/item/bodypart/leg/right/mutant/vox_primalis
	icon_static = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_greyscale = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon = 'modular_nova/modules/better_vox/icons/bodyparts/vox_bodyparts.dmi'
	icon_state = "vox_primalis_r_leg"
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox_primalis
	should_draw_greyscale = FALSE
	limb_id = SPECIES_VOX_PRIMALIS

/datum/custom_bodytype/vox_primalis
	name = SPECIES_VOX_PRIMALIS
	worn_icons = list(
		LOADOUT_ITEM_HEAD = VOX_PRIMALIS_HEAD_ICON,
		LOADOUT_ITEM_MASK = VOX_PRIMALIS_MASK_ICON,
		LOADOUT_ITEM_SUIT = VOX_PRIMALIS_SUIT_ICON,
		LOADOUT_ITEM_UNIFORM = VOX_PRIMALIS_UNIFORM_ICON,
		LOADOUT_ITEM_GLOVES =  VOX_PRIMALIS_GLOVES_ICON,
		LOADOUT_ITEM_SHOES = VOX_PRIMALIS_FEET_ICON,
		LOADOUT_ITEM_GLASSES = VOX_PRIMALIS_EYES_ICON,
		LOADOUT_ITEM_BELT = VOX_PRIMALIS_BELT_ICON,
		LOADOUT_ITEM_MISC = VOX_PRIMALIS_BACK_ICON,
		LOADOUT_ITEM_EARS = VOX_PRIMALIS_EARS_ICON,
	)

/datum/custom_bodytype/vox_primalis/get_worn_icon(item_slot, obj/item/item, obj/item/bodypart/limb)
	return item.worn_icon_better_vox

/datum/custom_bodytype/vox_primalis/set_worn_icon(item_slot, obj/item/item, icon/icon)
	item.worn_icon_better_vox = icon
