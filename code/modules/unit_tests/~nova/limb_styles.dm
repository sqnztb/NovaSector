/// Makes sure every limb selectable in character creation can actually be drawn, digitigrade variants included.
/datum/unit_test/selectable_limb_styles

/datum/unit_test/selectable_limb_styles/Run()
	TEST_ASSERT(length(GLOB.selectable_limb_styles), "No selectable limb styles were found!")

	for(var/zone in GLOB.selectable_limb_styles)
		var/list/styles = GLOB.selectable_limb_styles[zone]
		for(var/style_name in styles)
			var/obj/item/bodypart/limb_type = styles[style_name]
			TEST_ASSERT_EQUAL(initial(limb_type.body_zone), zone, "Limb style \"[style_name]\" ([limb_type]) is listed under the wrong zone.")
			check_limb(limb_type, style_name)

			if(!ispath(limb_type, /obj/item/bodypart/leg))
				continue
			var/obj/item/bodypart/leg/leg_type = limb_type
			var/obj/item/bodypart/digi_type = initial(leg_type.digitigrade_type)
			if(digi_type && digi_type != limb_type)
				check_limb(digi_type, "[style_name] (digitigrade)")

/datum/unit_test/selectable_limb_styles/proc/check_limb(obj/item/bodypart/limb_type, style_name)
	var/obj/item/bodypart/limb = allocate(limb_type)
	var/icon_file = limb.should_draw_greyscale ? limb.icon_greyscale : limb.icon_static
	if(!icon_file)
		TEST_FAIL("Limb style \"[style_name]\" ([limb_type]) has no icon file.")
		return

	var/digi_suffix = (limb.bodyshape & BODYSHAPE_DIGITIGRADE) ? "_[ICON_KEY_DIGI]" : ""
	var/list/genders = limb.is_dimorphic ? list("m", "f") : list(null)
	for(var/gender in genders)
		var/state = "[limb.limb_id]_[limb.body_zone][gender ? "_[gender]" : ""][digi_suffix]"
		if(!icon_exists(icon_file, state))
			TEST_FAIL("Limb style \"[style_name]\" ([limb_type]) is missing icon state \"[state]\" in [icon_file].")
