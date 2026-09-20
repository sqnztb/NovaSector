/**
 * # Custom bodytypes
 *
 * Describes how clothing is drawn on a BODYSHAPE_CUSTOM bodypart (vox, teshari, etc).
 *
 * This used to live on the species, which meant clothing sprites only worked if your *species* matched.
 * It now lives on the bodypart (see `/obj/item/bodypart/var/custom_bodytype`), so a limb brings its clothing sprites
 * with it no matter which species it is attached to.
 *
 * These are singletons, fetched with `get_custom_bodytype()`.
 */
/datum/custom_bodytype
	/// Unique name, used as the key for the generated icon cache.
	var/name = "abstract"
	/// Assoc list of LOADOUT_ITEM_X => /icon to look up worn icon states in.
	var/list/worn_icons = list()

/// Returns the singleton instance of the given custom bodytype type.
/proc/get_custom_bodytype(datum/custom_bodytype/bodytype_type)
	if(!ispath(bodytype_type, /datum/custom_bodytype))
		return null
	var/datum/custom_bodytype/bodytype = GLOB.custom_bodytypes[bodytype_type]
	if(!bodytype)
		bodytype = new bodytype_type
		GLOB.custom_bodytypes[bodytype_type] = bodytype
	return bodytype

/**
 * Returns the bodypart whose custom bodytype decides how an item in the given slot is drawn.
 * Headwear follows the head, gloves follow the arms, shoes follow the legs, everything else follows the chest.
 */
/mob/living/carbon/human/proc/get_custom_bodytype_limb(item_slot)
	switch(item_slot)
		if(LOADOUT_ITEM_HEAD, LOADOUT_ITEM_MASK, LOADOUT_ITEM_GLASSES, LOADOUT_ITEM_EARS)
			return get_bodypart(BODY_ZONE_HEAD)
		if(LOADOUT_ITEM_GLOVES)
			return get_first_custom_bodytype_limb(GLOB.arm_zones)
		if(LOADOUT_ITEM_SHOES)
			return get_first_custom_bodytype_limb(GLOB.leg_zones)
	return get_bodypart(BODY_ZONE_CHEST)

/// Returns the first bodypart in the given zones that has a custom bodytype, or the first existing one if none do.
/mob/living/carbon/human/proc/get_first_custom_bodytype_limb(list/zones)
	var/obj/item/bodypart/fallback
	for(var/zone in zones)
		var/obj/item/bodypart/limb = get_bodypart(zone)
		if(!limb)
			continue
		if(limb.custom_bodytype)
			return limb
		fallback ||= limb
	return fallback

/**
 * Allow for custom clothing icon generation. Only called if the human is BODYSHAPE_CUSTOM.
 * If null is returned, use default human icon.
 * Arguments:
 * * item_slot: The slot we're updating. One of LOADOUT_ITEM_HEAD, etc.
 * * item: The item being rendered.
 */
/mob/living/carbon/human/proc/generate_custom_worn_icon(item_slot, obj/item/item)
	var/obj/item/bodypart/limb = get_custom_bodytype_limb(item_slot)
	if(!limb?.custom_bodytype)
		return null
	var/datum/custom_bodytype/bodytype = get_custom_bodytype(limb.custom_bodytype)
	return bodytype?.generate_worn_icon(item_slot, item, src, limb)

/// Returns the custom worn icon list entry for the given slot, as decided by the relevant bodypart. Null if none.
/mob/living/carbon/human/proc/get_custom_worn_icon_file(item_slot)
	var/obj/item/bodypart/limb = get_custom_bodytype_limb(item_slot)
	if(!limb?.custom_bodytype)
		return null
	var/datum/custom_bodytype/bodytype = get_custom_bodytype(limb.custom_bodytype)
	return bodytype?.worn_icons[item_slot]

/**
 * Modularly returns one of worn_icon_vox, worn_icon_teshari, etc.
 * Arguments:
 * * item_slot: The slot we're updating. One of LOADOUT_ITEM_HEAD, etc.
 * * item: The item we're checking.
 * * limb: The bodypart that decided this bodytype is used.
 */
/datum/custom_bodytype/proc/get_worn_icon(item_slot, obj/item/item, obj/item/bodypart/limb)
	return null

/**
 * Modularly set one of worn_icon_vox, worn_icon_teshari, etc.
 * Arguments:
 * * item_slot: The slot we're updating. One of LOADOUT_ITEM_HEAD, etc.
 * * item: The item we're updating.
 * * icon: The icon we're setting to the var.
 */
/datum/custom_bodytype/proc/set_worn_icon(item_slot, obj/item/item, icon/icon)
	return

/**
 * Modularly get the bodytype's fallback greyscale config.
 * Only used if you use generate_worn_icon_fallback()
 * Arguments:
 * * item_slot: The slot we're updating. One of LOADOUT_ITEM_HEAD, etc.
 * * item: The item being rendered.
 */
/datum/custom_bodytype/proc/get_worn_config_fallback(item_slot, obj/item/item)
	CRASH("`get_worn_config_fallback()` was not implemented for [type]!")

/datum/custom_bodytype/proc/use_worn_icon_cache()
	LAZYINITLIST(GLOB.custom_bodytype_clothing_cache[name])

/**
 * Read from freely usable cache of generated icons for this bodytype.
 * Arguments:
 * * file_to_use: icon you're substituting
 * * state_to_use: icon state you're substituting
 * * meta: string containing other info.
 */
/datum/custom_bodytype/proc/get_worn_icon_cached(file_to_use, state_to_use, meta)
	return GLOB.custom_bodytype_clothing_cache[name]["[file_to_use]-[state_to_use]-[meta]"]

/**
 * Write to a freely usable cache of generated icons for this bodytype.
 * Arguments:
 * * file_to_use: icon you're substituting
 * * state_to_use: icon state you're substituting
 * * meta: string containing other info.
 * * cached_value: Cached value
 */
/datum/custom_bodytype/proc/set_worn_icon_cached(file_to_use, state_to_use, meta, cached_value)
	GLOB.custom_bodytype_clothing_cache[name]["[file_to_use]-[state_to_use]-[meta]"] = cached_value

/**
 * Generates the worn icon for an item on this bodytype.
 * If null is returned, use default human icon.
 * Arguments:
 * * item_slot: The slot we're updating. One of LOADOUT_ITEM_HEAD, etc.
 * * item: The item being rendered.
 * * human_owner: The human wearing the item.
 * * limb: The bodypart that decided this bodytype is used.
 */
/datum/custom_bodytype/proc/generate_worn_icon(item_slot, obj/item/item, mob/living/carbon/human/human_owner, obj/item/bodypart/limb)
	// If already set (possibly by us, or manually, use it.)
	var/icon/final_icon = get_worn_icon(item_slot, item, limb)
	if(final_icon && icon_exists(final_icon, item.worn_icon_state || item.icon_state)) // TODO: UNIT TEST teshari_worn_icon beforehand
		return final_icon

	// Else check if in custom icon.
	if(!(item_slot in worn_icons))
		return null

	var/icon/bodytype_worn_icon = worn_icons[item_slot]
	var/static/list/state_cache = list() // cache these so we are not calling the expensive icon_states proc.
	var/list/states = state_cache[bodytype_worn_icon]
	if(!states)
		states = icon_states(bodytype_worn_icon)
		state_cache[bodytype_worn_icon] = states

	var/state = item.worn_icon_state || item.icon_state
	if(!(state in states))
		return null

	// Remember and use icon.
	set_worn_icon(item_slot, item, bodytype_worn_icon)
	return bodytype_worn_icon

/**
 * Generate a fallback worn icon, if the bodytype supports it. You must call it in an override of generate_worn_icon()
 */
/datum/custom_bodytype/proc/generate_worn_icon_fallback(item_slot, obj/item/item, mob/living/carbon/human/human_owner)
	var/icon/human_icon = item.worn_icon || item.icon
	var/human_icon_state = item.worn_icon_state || item.icon_state

	// Key for greyscale string (color "x" means non-gags/unknown)
	var/greyscale_key = item.greyscale_colors || "x"

	// First, let's just check if we've already made this.
	use_worn_icon_cache()
	var/icon/cached_icon = get_worn_icon_cached(human_icon, human_icon_state, greyscale_key)
	if(cached_icon)
		return cached_icon

	// Get GAGs config
	var/fallback_config = get_worn_config_fallback(item_slot, item)
	if(!fallback_config)
		return null

	// The GAGs config needs this many colors.
	var/expected_num_colors = SSgreyscale.configurations["[fallback_config]"].expected_colors
	// The colors string.
	var/fallback_greyscale_colors

	// If this outfit is already GAGs, use the existing colors.
	// Case 1: item already has greyscale
	if(item.greyscale_colors)
		var/list/colors = SSgreyscale.ParseColorString(item.greyscale_colors)
		var/default_color = length(colors) ? colors[1] : COLOR_DARK

		var/list/final_colors = new /list(expected_num_colors)

		var/colors_len = length(colors)
		for(var/i in 1 to expected_num_colors)
			if(i <= colors_len)
				final_colors[i] = colors[i]
			else
				final_colors[i] = default_color

		fallback_greyscale_colors = final_colors.Join("")

	else
		// Case 2: // we have to actually guess the colors via pixel sampling
		var/icon/temp_icon = icon(human_icon, human_icon_state)
		var/list/color_list = new /list(expected_num_colors)

		var/list/coords = item.species_clothing_color_coords

		// extract pixels without additional bounds checks
		for(var/i in 1 to expected_num_colors)
			if(i > length(coords))
				color_list[i] = COLOR_DARK
				continue

			var/coord = coords[i]
			var/pixel = temp_icon.GetPixel(coord[1], coord[2])
			color_list[i] = pixel || COLOR_DARK

		fallback_greyscale_colors = color_list.Join("")

	// Finally, render with GAGs
	var/icon/final_icon = icon(SSgreyscale.GetColoredIconByType(fallback_config, fallback_greyscale_colors))
	final_icon.Insert(final_icon, icon_state = human_icon_state) // include the expected icon_state
	final_icon = fcopy_rsc(final_icon)
	// Duplicate to the specific icon_state and set.
	// Cache the clean copy.
	set_worn_icon_cached(human_icon, human_icon_state, greyscale_key, final_icon)

	return final_icon
