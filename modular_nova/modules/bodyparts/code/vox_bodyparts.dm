// voxs!
/obj/item/bodypart/head/mutant/vox
	icon_greyscale = BODYPART_ICON_VOX
	bodyshape = parent_type::bodyshape | BODYSHAPE_SNOUTED | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox
	limb_id = SPECIES_VOX
	eyes_icon = 'modular_nova/modules/organs/icons/vox_eyes.dmi'
	teeth_count = 72

/obj/item/bodypart/chest/mutant/vox
	icon_greyscale = BODYPART_ICON_VOX
	bodyshape = parent_type::bodyshape | BODYSHAPE_SNOUTED | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox
	limb_id = SPECIES_VOX

/obj/item/bodypart/arm/left/mutant/vox
	icon_greyscale = BODYPART_ICON_VOX
	bodyshape = parent_type::bodyshape | BODYSHAPE_SNOUTED | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox
	limb_id = SPECIES_VOX

/obj/item/bodypart/arm/right/mutant/vox
	icon_greyscale = BODYPART_ICON_VOX
	bodyshape = parent_type::bodyshape | BODYSHAPE_SNOUTED | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox
	limb_id = SPECIES_VOX

/obj/item/bodypart/leg/left/mutant/vox
	icon_greyscale = BODYPART_ICON_VOX
	bodyshape = parent_type::bodyshape | BODYSHAPE_SNOUTED | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox
	limb_id = SPECIES_VOX
	digitigrade_type = /obj/item/bodypart/leg/left/digitigrade/vox

/obj/item/bodypart/leg/right/mutant/vox
	icon_greyscale = BODYPART_ICON_VOX
	bodyshape = parent_type::bodyshape | BODYSHAPE_SNOUTED | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox
	limb_id = SPECIES_VOX
	digitigrade_type = /obj/item/bodypart/leg/right/digitigrade/vox

/obj/item/bodypart/leg/left/digitigrade/vox
	icon_greyscale = BODYPART_ICON_VOX
	bodyshape = parent_type::bodyshape | BODYSHAPE_SNOUTED | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox
	limb_id = SPECIES_VOX

/obj/item/bodypart/leg/right/digitigrade/vox
	icon_greyscale = BODYPART_ICON_VOX
	bodyshape = parent_type::bodyshape | BODYSHAPE_SNOUTED | BODYSHAPE_CUSTOM
	custom_bodytype = /datum/custom_bodytype/vox
	limb_id = SPECIES_VOX

/datum/custom_bodytype/vox
	name = SPECIES_VOX
	worn_icons = list(
		LOADOUT_ITEM_HEAD = VOX_HEAD_ICON,
		LOADOUT_ITEM_MASK = VOX_MASK_ICON,
		LOADOUT_ITEM_SUIT = VOX_SUIT_ICON,
		LOADOUT_ITEM_UNIFORM = VOX_UNIFORM_ICON,
		LOADOUT_ITEM_HANDS =  VOX_HANDS_ICON,
		LOADOUT_ITEM_SHOES = VOX_FEET_ICON,
		LOADOUT_ITEM_GLASSES = VOX_EYES_ICON,
		LOADOUT_ITEM_BELT = VOX_BELT_ICON,
		LOADOUT_ITEM_MISC = VOX_BACK_ICON,
		LOADOUT_ITEM_EARS = VOX_EARS_ICON
	)

/datum/custom_bodytype/vox/get_worn_icon(item_slot, obj/item/item, obj/item/bodypart/limb)
	// snowflakey but vox legs weird. Vox use normal human shoes (digitigrade-capable shoes are handled before we get here).
	// This used to check the species' default (non-digitigrade) leg, so the vox feet icons were never actually used for shoes.
	// Kept that way for visual parity. To let digitigrade vox use VOX_FEET_ICON, check `limb.bodyshape & BODYSHAPE_DIGITIGRADE` here.
	if(item_slot == LOADOUT_ITEM_SHOES)
		return DEFAULT_SHOES_FILE

	return item.worn_icon_vox

/datum/custom_bodytype/vox/set_worn_icon(item_slot, obj/item/item, icon/icon)
	item.worn_icon_vox = icon
