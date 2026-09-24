#define MASK_SNOUT_EXTRA_OFFSET_X 1
#define MASK_SNOUT_EXTRA_OFFSET_Y 1

/obj/item
	var/datum/greyscale_config/greyscale_config_worn_teshari_fallback
	var/datum/greyscale_config/greyscale_config_worn_teshari_fallback_skirt

/datum/custom_bodytype/teshari
	name = SPECIES_TESHARI
	worn_icons = list(
		LOADOUT_ITEM_HEAD = TESHARI_HEAD_ICON,
		LOADOUT_ITEM_MASK = TESHARI_MASK_ICON,
		LOADOUT_ITEM_NECK = TESHARI_NECK_ICON,
		LOADOUT_ITEM_SUIT = TESHARI_SUIT_ICON,
		LOADOUT_ITEM_UNIFORM = TESHARI_UNIFORM_ICON,
		LOADOUT_ITEM_HANDS =  TESHARI_HANDS_ICON,
		LOADOUT_ITEM_SHOES = TESHARI_FEET_ICON,
		LOADOUT_ITEM_GLASSES = TESHARI_EYES_ICON,
		LOADOUT_ITEM_BELT = TESHARI_BELT_ICON,
		LOADOUT_ITEM_MISC = TESHARI_BACK_ICON,
		LOADOUT_ITEM_ACCESSORY = TESHARI_ACCESSORIES_ICON,
		LOADOUT_ITEM_EARS = TESHARI_EARS_ICON
	)

/datum/custom_bodytype/teshari/get_worn_icon(item_slot, obj/item/item, obj/item/bodypart/limb)
	return item.worn_icon_teshari

/datum/custom_bodytype/teshari/set_worn_icon(item_slot, obj/item/item, icon/icon)
	item.worn_icon_teshari = icon

/datum/custom_bodytype/teshari/get_worn_config_fallback(item_slot, obj/item/item)
	// skirt support
	if(istype(item, /obj/item/clothing/under) && !(item.body_parts_covered & LEGS))
		return item.greyscale_config_worn_teshari_fallback_skirt

	return item.greyscale_config_worn_teshari_fallback

/datum/custom_bodytype/teshari/generate_worn_icon(item_slot, obj/item/item, mob/living/carbon/human/human_owner, obj/item/bodypart/limb)
	. = ..()
	if(.)
		return

	// Use the fancy fallback sprites.
	. = generate_worn_icon_fallback(item_slot, item, human_owner)
	if(.)
		return

	// If there isn't even a fallback, use snouted sprites for masks and helmets, but offsetted
	if((item_slot == LOADOUT_ITEM_MASK || item_slot == LOADOUT_ITEM_HEAD) && (item.supports_variations_flags & CLOTHING_SNOUTED_VARIATION))
		var/obj/item/bodypart/head/my_head = human_owner.get_bodypart(BODY_ZONE_HEAD)
		var/datum/worn_feature_offset/selected_offset
		var/human_icon
		var/human_icon_state = item.worn_icon_state || item.icon_state
		if(item_slot == LOADOUT_ITEM_HEAD)

			human_icon = item.worn_icon_muzzled || SNOUTED_HEAD_FILE
			selected_offset = my_head?.worn_head_offset
		else
			human_icon = item.worn_icon_muzzled || SNOUTED_MASK_FILE
			selected_offset = my_head?.worn_mask_offset

		//#ifdef UNIT_TESTS - TODO - Unit test supports_variations_flags
		// Did the snout variation flag lie to us?
		if(!icon_exists(human_icon, human_icon_state))
			return
		//#endif

		// Use already resolved icon
		use_worn_icon_cache()
		var/icon/cached_icon = get_worn_icon_cached(human_icon, human_icon_state, "m")
		if(cached_icon)
			return cached_icon

		// Generate muzzled icon, but offset
		var/icon/new_icon = icon('icons/blanks/32x32.dmi', "nothing")
		new_icon.Blend(icon(human_icon, human_icon_state), ICON_OVERLAY, x = selected_offset.offset_x["north"], y = selected_offset.offset_y["north"])
		new_icon.Insert(new_icon, human_icon_state)
		new_icon = fcopy_rsc(new_icon)
		set_worn_icon_cached(human_icon, human_icon_state, "m", new_icon)
		return new_icon

#undef MASK_SNOUT_EXTRA_OFFSET_X
#undef MASK_SNOUT_EXTRA_OFFSET_Y
