/// Legs
/datum/preference/choiced/digitigrade_legs
	savefile_key = "digitigrade_legs"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_mutant_bodypart = FEATURE_LEGS

/datum/preference/choiced/digitigrade_legs/create_default_value()
	return NORMAL_LEGS

/datum/preference/choiced/digitigrade_legs/init_possible_values()
	return list(NORMAL_LEGS, DIGITIGRADE_LEGS)

/datum/preference/choiced/digitigrade_legs/is_accessible(datum/preferences/preferences)
	return ..() && is_usable(preferences)

/**
 * Actually rendered. Slimmed down version of the logic in is_available() that actually works when spawning or drawing the character.
 *
 * Returns if feature value is usable.
 *
 * Arguments:
 * * preferences - The relevant character preferences.
 */
/datum/preference/choiced/digitigrade_legs/proc/is_usable(datum/preferences/preferences)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = GLOB.species_prototypes[species_type]

	return (savefile_key in species.get_features()) \
		&& species.digitigrade_customization == DIGITIGRADE_OPTIONAL

/datum/preference/choiced/digitigrade_legs/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!preferences || !is_usable(preferences))
		return FALSE

	var/old_value = target.dna.features[FEATURE_LEGS]
	if(value == old_value)
		return FALSE

	target.dna.features[FEATURE_LEGS] = value

	target.update_body()
	// We only record the feature here. Swapping the limbs over is left to reconcile_digitigrade_limbs(), which
	// apply_prefs_to() calls once the species preference has been applied - this preference runs at
	// PREFERENCE_PRIORITY_DEFAULT, so target.dna.species is still the *old* species at this point.
	return TRUE

/**
 * Returns whether this human's legs should currently be digitigrade.
 *
 * Reads the species' digitigrade_customization, falling back to the DNA feature where the species leaves
 * the choice up to the player.
 */
/mob/living/carbon/human/proc/should_have_digitigrade_legs()
	var/datum/species/our_species = dna?.species
	if(isnull(our_species))
		return FALSE

	switch(our_species.digitigrade_customization)
		if(DIGITIGRADE_FORCED)
			return TRUE
		if(DIGITIGRADE_OPTIONAL)
			return dna.features[FEATURE_LEGS] == DIGITIGRADE_LEGS

	return FALSE

/**
 * Swaps this human's limbs over when its current leg shape disagrees with what its species and features call for.
 *
 * set_species() only reaches replace_body() when the species type actually changes, so a mob that was created
 * already wearing its final species - every ghost role spawner that sets mob_species - never gets its legs
 * configured at all. This is the backstop for that.
 *
 * Returns TRUE if the body was replaced.
 */
/mob/living/carbon/human/proc/reconcile_digitigrade_limbs()
	if(isnull(dna?.species))
		return FALSE

	var/has_digitigrade = FALSE
	for(var/obj/item/bodypart/leg/leg in bodyparts)
		if(leg.bodyshape & BODYSHAPE_DIGITIGRADE)
			has_digitigrade = TRUE
			break

	if(should_have_digitigrade_legs() == has_digitigrade)
		return FALSE

	// Note that replace_body() can decline to go digitigrade anyway - a synth whose chassis isn't digi compatible,
	// for one - in which case we'll retry on the next apply_prefs_to(). That's one wasted call, not a loop.
	dna.species.replace_body(src, dna.species)
	return TRUE
