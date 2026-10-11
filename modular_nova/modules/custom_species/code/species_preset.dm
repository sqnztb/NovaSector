/**
 * # Species presets
 *
 * A preset is what used to be a whole species: a named bundle of body parts, organs, mutant parts and heritage quirks.
 * Picking one in character creation fills all of that in on the custom species, and the player can tweak it afterwards.
 *
 * The chosen preset is also saved as the character's heritage (`FEATURE_HERITAGE`), which is their lore species.
 * Species checks treat a custom-species mob as its heritage's `legacy_species_type`, see `/datum/species/var/uses_heritage`.
 */
/datum/species_preset
	abstract_type = /datum/species_preset
	/// Unique id. Matches the id of the species this preset replaces, so `recommended_species` lists and savefile migration keep working.
	var/id
	/// Display name.
	var/name
	/// The species type this preset replaces. Species checks on custom-species mobs with this heritage treat them as this type.
	var/datum/species/legacy_species_type

/// Builds the id => instance list of all presets.
/proc/init_species_presets()
	var/list/presets = list()
	for(var/datum/species_preset/preset_type as anything in valid_subtypesof(/datum/species_preset))
		var/datum/species_preset/preset = new preset_type
		if(!preset.id)
			stack_trace("Species preset [preset_type] has no id!")
			continue
		if(presets[preset.id])
			stack_trace("Species preset [preset_type] has a duplicate id ([preset.id]) with [presets[preset.id].type]!")
			continue
		presets[preset.id] = preset
	return presets

/// All species presets, id => instance.
GLOBAL_LIST_INIT(species_presets, init_species_presets())
