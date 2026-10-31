/obj/item/bodypart
	/**
	 * Name this limb shows up as in the character creation body part picker, e.g. "Vox". Null means it can't be picked.
	 *
	 * Only counts on the type that sets it: subtypes inheriting the same name are not selectable on their own.
	 * To make a new limb set selectable, set this on each of its bodyparts.
	 */
	var/pref_style_name

/**
 * Builds BODY_ZONE_X => list(style name => bodypart typepath) of every bodypart selectable in character creation.
 * A bodypart is selectable if it sets `pref_style_name` itself, rather than inheriting it.
 */
/proc/init_selectable_limb_styles()
	var/list/styles = list()
	for(var/obj/item/bodypart/limb_type as anything in subtypesof(/obj/item/bodypart) + /obj/item/bodypart)
		var/style_name = initial(limb_type.pref_style_name)
		if(isnull(style_name))
			continue
		var/obj/item/bodypart/parent_limb_type = limb_type::parent_type
		if(ispath(parent_limb_type, /obj/item/bodypart) && initial(parent_limb_type.pref_style_name) == style_name)
			continue
		var/zone = initial(limb_type.body_zone)
		LAZYINITLIST(styles[zone])
		if(styles[zone][style_name])
			stack_trace("Duplicate limb style \"[style_name]\" for [zone]: [limb_type] and [styles[zone][style_name]].")
			continue
		styles[zone][style_name] = limb_type
	return styles

/// BODY_ZONE_X => list(style name => bodypart typepath) of every bodypart selectable in character creation.
GLOBAL_LIST_INIT(selectable_limb_styles, init_selectable_limb_styles())

// Selectable limbs. Generated from the species limb augments (species_limbs.dm), which these will replace.
// Limbs added later can set `pref_style_name` in their own file instead.

// Akula
/obj/item/bodypart/arm/left/mutant/akula
	pref_style_name = "Akula"
/obj/item/bodypart/arm/right/mutant/akula
	pref_style_name = "Akula"
/obj/item/bodypart/chest/mutant/akula
	pref_style_name = "Akula"
/obj/item/bodypart/head/mutant/akula
	pref_style_name = "Akula"
/obj/item/bodypart/leg/left/mutant/akula
	pref_style_name = "Akula"
/obj/item/bodypart/leg/right/mutant/akula
	pref_style_name = "Akula"

// Anthromorph
/obj/item/bodypart/arm/left/mutant
	pref_style_name = "Anthromorph"
/obj/item/bodypart/arm/right/mutant
	pref_style_name = "Anthromorph"
/obj/item/bodypart/chest/mutant
	pref_style_name = "Anthromorph"
/obj/item/bodypart/head/mutant
	pref_style_name = "Anthromorph"
/obj/item/bodypart/leg/left/mutant
	pref_style_name = "Anthromorph"
/obj/item/bodypart/leg/right/mutant
	pref_style_name = "Anthromorph"

// Aquatic
/obj/item/bodypart/arm/left/mutant/aquatic
	pref_style_name = "Aquatic"
/obj/item/bodypart/arm/right/mutant/aquatic
	pref_style_name = "Aquatic"
/obj/item/bodypart/chest/mutant/aquatic
	pref_style_name = "Aquatic"
/obj/item/bodypart/head/mutant/aquatic
	pref_style_name = "Aquatic"
/obj/item/bodypart/leg/left/mutant/aquatic
	pref_style_name = "Aquatic"
/obj/item/bodypart/leg/right/mutant/aquatic
	pref_style_name = "Aquatic"

// Big-eyes ramatae
/obj/item/bodypart/head/mutant/ramatae/eyes
	pref_style_name = "Big-eyes ramatae"

// Ethereal
/obj/item/bodypart/arm/left/ethereal
	pref_style_name = "Ethereal"
/obj/item/bodypart/arm/right/ethereal
	pref_style_name = "Ethereal"
/obj/item/bodypart/chest/ethereal
	pref_style_name = "Ethereal"
/obj/item/bodypart/head/ethereal
	pref_style_name = "Ethereal"
/obj/item/bodypart/leg/left/ethereal
	pref_style_name = "Ethereal"
/obj/item/bodypart/leg/right/ethereal
	pref_style_name = "Ethereal"

// Fly
/obj/item/bodypart/arm/left/fly
	pref_style_name = "Fly"
/obj/item/bodypart/arm/right/fly
	pref_style_name = "Fly"
/obj/item/bodypart/chest/fly
	pref_style_name = "Fly"
/obj/item/bodypart/head/fly
	pref_style_name = "Fly"
/obj/item/bodypart/leg/left/fly
	pref_style_name = "Fly"
/obj/item/bodypart/leg/right/fly
	pref_style_name = "Fly"

// Golem
/obj/item/bodypart/arm/left/golem
	pref_style_name = "Golem"
/obj/item/bodypart/arm/right/golem
	pref_style_name = "Golem"
/obj/item/bodypart/chest/golem
	pref_style_name = "Golem"
/obj/item/bodypart/head/golem
	pref_style_name = "Golem"
/obj/item/bodypart/leg/left/golem
	pref_style_name = "Golem"
/obj/item/bodypart/leg/right/golem
	pref_style_name = "Golem"

// Harpy
/obj/item/bodypart/leg/left/mutant/harpy
	pref_style_name = "Harpy"
/obj/item/bodypart/leg/right/mutant/harpy
	pref_style_name = "Harpy"

// Harpy skintone
/obj/item/bodypart/leg/left/mutant/harpy_skin
	pref_style_name = "Harpy skintone"
/obj/item/bodypart/leg/right/mutant/harpy_skin
	pref_style_name = "Harpy skintone"

// Human
/obj/item/bodypart/arm/left
	pref_style_name = "Human"
/obj/item/bodypart/arm/right
	pref_style_name = "Human"
/obj/item/bodypart/chest
	pref_style_name = "Human"
/obj/item/bodypart/head
	pref_style_name = "Human"
/obj/item/bodypart/leg/left
	pref_style_name = "Human"
/obj/item/bodypart/leg/right
	pref_style_name = "Human"

// Insect
/obj/item/bodypart/arm/left/mutant/insect
	pref_style_name = "Insect"
/obj/item/bodypart/arm/right/mutant/insect
	pref_style_name = "Insect"
/obj/item/bodypart/chest/mutant/insect
	pref_style_name = "Insect"
/obj/item/bodypart/head/mutant/insect
	pref_style_name = "Insect"
/obj/item/bodypart/leg/left/mutant/insect
	pref_style_name = "Insect"
/obj/item/bodypart/leg/right/mutant/insect
	pref_style_name = "Insect"

// Lizard
/obj/item/bodypart/arm/left/lizard
	pref_style_name = "Lizard"
/obj/item/bodypart/arm/right/lizard
	pref_style_name = "Lizard"
/obj/item/bodypart/chest/lizard
	pref_style_name = "Lizard"
/obj/item/bodypart/head/lizard
	pref_style_name = "Lizard"
/obj/item/bodypart/leg/left/lizard
	pref_style_name = "Lizard"
/obj/item/bodypart/leg/right/lizard
	pref_style_name = "Lizard"

// Moth
/obj/item/bodypart/arm/left/moth
	pref_style_name = "Moth"
/obj/item/bodypart/arm/right/moth
	pref_style_name = "Moth"
/obj/item/bodypart/chest/moth
	pref_style_name = "Moth"
/obj/item/bodypart/head/moth
	pref_style_name = "Moth"
/obj/item/bodypart/leg/left/moth
	pref_style_name = "Moth"
/obj/item/bodypart/leg/right/moth
	pref_style_name = "Moth"

// Mushroom
/obj/item/bodypart/arm/left/mushroom
	pref_style_name = "Mushroom"
/obj/item/bodypart/arm/right/mushroom
	pref_style_name = "Mushroom"
/obj/item/bodypart/chest/mushroom
	pref_style_name = "Mushroom"
/obj/item/bodypart/head/mushroom
	pref_style_name = "Mushroom"
/obj/item/bodypart/leg/left/mushroom
	pref_style_name = "Mushroom"
/obj/item/bodypart/leg/right/mushroom
	pref_style_name = "Mushroom"

// Pod
/obj/item/bodypart/arm/left/pod
	pref_style_name = "Pod"
/obj/item/bodypart/arm/right/pod
	pref_style_name = "Pod"
/obj/item/bodypart/chest/pod
	pref_style_name = "Pod"
/obj/item/bodypart/head/pod
	pref_style_name = "Pod"
/obj/item/bodypart/leg/left/pod
	pref_style_name = "Pod"
/obj/item/bodypart/leg/right/pod
	pref_style_name = "Pod"

// Ramatae
/obj/item/bodypart/arm/left/mutant/ramatae
	pref_style_name = "Ramatae"
/obj/item/bodypart/arm/right/mutant/ramatae
	pref_style_name = "Ramatae"
/obj/item/bodypart/chest/mutant/ramatae
	pref_style_name = "Ramatae"
/obj/item/bodypart/leg/left/mutant/ramatae
	pref_style_name = "Ramatae"
/obj/item/bodypart/leg/right/mutant/ramatae
	pref_style_name = "Ramatae"

// Shadekin
/obj/item/bodypart/arm/left/mutant/shadekin
	pref_style_name = "Shadekin"
/obj/item/bodypart/arm/right/mutant/shadekin
	pref_style_name = "Shadekin"
/obj/item/bodypart/chest/mutant/shadekin
	pref_style_name = "Shadekin"
/obj/item/bodypart/head/mutant/shadekin
	pref_style_name = "Shadekin"
/obj/item/bodypart/leg/left/mutant/shadekin
	pref_style_name = "Shadekin"
/obj/item/bodypart/leg/right/mutant/shadekin
	pref_style_name = "Shadekin"

// Skintone mutant
/obj/item/bodypart/leg/left/human_digi_capable
	pref_style_name = "Skintone mutant"
/obj/item/bodypart/leg/right/human_digi_capable
	pref_style_name = "Skintone mutant"

// Skrell
/obj/item/bodypart/arm/left/mutant/skrell
	pref_style_name = "Skrell"
/obj/item/bodypart/arm/right/mutant/skrell
	pref_style_name = "Skrell"
/obj/item/bodypart/chest/mutant/skrell
	pref_style_name = "Skrell"
/obj/item/bodypart/head/mutant/skrell
	pref_style_name = "Skrell"
/obj/item/bodypart/leg/left/mutant/skrell
	pref_style_name = "Skrell"
/obj/item/bodypart/leg/right/mutant/skrell
	pref_style_name = "Skrell"

// Slime
/obj/item/bodypart/arm/left/jelly/slime/roundstart
	pref_style_name = "Slime"
/obj/item/bodypart/arm/right/jelly/slime/roundstart
	pref_style_name = "Slime"
/obj/item/bodypart/chest/jelly/slime/roundstart
	pref_style_name = "Slime"
/obj/item/bodypart/head/jelly/slime/roundstart
	pref_style_name = "Slime"
/obj/item/bodypart/leg/left/jelly/slime/roundstart
	pref_style_name = "Slime"
/obj/item/bodypart/leg/right/jelly/slime/roundstart
	pref_style_name = "Slime"

// Small-eyes ramatae
/obj/item/bodypart/head/mutant/ramatae
	pref_style_name = "Small-eyes ramatae"

// Vox
/obj/item/bodypart/arm/left/mutant/vox
	pref_style_name = "Vox"
/obj/item/bodypart/arm/right/mutant/vox
	pref_style_name = "Vox"
/obj/item/bodypart/chest/mutant/vox
	pref_style_name = "Vox"
/obj/item/bodypart/head/mutant/vox
	pref_style_name = "Vox"
/obj/item/bodypart/leg/left/mutant/vox
	pref_style_name = "Vox"
/obj/item/bodypart/leg/right/mutant/vox
	pref_style_name = "Vox"

// Xenohybrid
/obj/item/bodypart/arm/left/mutant/xenohybrid
	pref_style_name = "Xenohybrid"
/obj/item/bodypart/arm/right/mutant/xenohybrid
	pref_style_name = "Xenohybrid"
/obj/item/bodypart/chest/mutant/xenohybrid
	pref_style_name = "Xenohybrid"
/obj/item/bodypart/head/mutant/xenohybrid
	pref_style_name = "Xenohybrid"
/obj/item/bodypart/leg/left/digitigrade/xenohybrid
	pref_style_name = "Xenohybrid"
/obj/item/bodypart/leg/right/digitigrade/xenohybrid
	pref_style_name = "Xenohybrid"
