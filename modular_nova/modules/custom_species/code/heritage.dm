/datum/species
	/**
	 * If TRUE, species checks (`is_species()`, `ishumanbasic()`) on mobs of this species also match the legacy species
	 * of the heritage stored in their DNA. See `/datum/species_preset`.
	 *
	 * This is what lets a custom-species character with vox heritage still count as a vox for `isvox()` and friends,
	 * without having to touch every species check in the codebase.
	 */
	var/uses_heritage = FALSE

/// Returns the `/datum/species_preset` matching this DNA's heritage, or null if it has none.
/datum/dna/proc/get_heritage()
	RETURN_TYPE(/datum/species_preset)
	return GLOB.species_presets[features[FEATURE_HERITAGE]]

/// Returns the legacy species type that species checks should treat this DNA as, or null if none applies.
/datum/dna/proc/get_heritage_species_type()
	if(!species?.uses_heritage)
		return null
	var/datum/species_preset/preset = get_heritage()
	return preset?.legacy_species_type

/**
 * Returns TRUE if this DNA's heritage counts as the given species type (or a subtype of it).
 * Mirrors `istype(dna.species, species_type)` for species checks.
 */
/datum/dna/proc/heritage_is_species(datum/species/species_type)
	var/datum/species/heritage_type = get_heritage_species_type()
	return !isnull(heritage_type) && ispath(heritage_type, species_type)
