/datum/quirk
	/**
	 * Is this a heritage quirk?
	 *
	 * Heritage quirks are species-like biology (what you breathe, your blood, special organs) that used to be baked into species.
	 * They are free, shown in their own color in the quirk menu, and handed out by species presets.
	 */
	var/heritage_quirk = FALSE

/**
 * # Heritage quirks
 *
 * Declarative base for heritage quirks. Set the vars, and the base type gives and takes away everything for you,
 * including after a species change, rejuvenation or organ regeneration.
 *
 * Organs are written onto the holder's species datum as well as inserted, so anything that regenerates organs
 * from the species (rejuvenate, revival, `regenerate_organs()`) keeps giving the heritage organs back.
 * The species datum is recreated on every species change, so we re-apply on `COMSIG_SPECIES_GAIN`.
 *
 * For one-off behaviour, override `apply_biology()` / `remove_biology()` and call the parent.
 */
/datum/quirk/heritage
	abstract_type = /datum/quirk/heritage
	value = 0
	heritage_quirk = TRUE
	icon = FA_ICON_DNA
	quirk_flags = QUIRK_HUMAN_ONLY
	/// Traits granted while we have this quirk, with the QUIRK_TRAIT source.
	var/list/granted_traits
	/// Organs to give, ORGAN_SLOT_X => organ typepath.
	var/list/organ_overrides
	/// Blood type to switch to, if any. A `/datum/blood_type` typepath.
	var/datum/blood_type/exotic_bloodtype
	/// Species that can't take this quirk, subtypes included. Usually hard species that have their own biology.
	var/list/incompatible_species

	/// The organ types the species had before we overrode them, ORGAN_SLOT_X => typepath (or null for none). Per species datum.
	VAR_PRIVATE/list/replaced_organ_types
	/// The blood type the holder had before we changed it.
	VAR_PRIVATE/datum/blood_type/old_bloodtype
	/// The species' exotic blood type before we changed it.
	VAR_PRIVATE/datum/blood_type/old_species_bloodtype

/datum/quirk/heritage/is_species_appropriate(datum/species/mob_species)
	for(var/datum/species/species_type as anything in incompatible_species)
		if(ispath(mob_species, species_type))
			return FALSE
	return ..()

/datum/quirk/heritage/add(client/client_source)
	if(length(granted_traits))
		quirk_holder.add_traits(granted_traits, QUIRK_TRAIT)
	RegisterSignal(quirk_holder, COMSIG_SPECIES_GAIN, PROC_REF(on_species_gain))
	apply_biology()

/datum/quirk/heritage/remove()
	UnregisterSignal(quirk_holder, COMSIG_SPECIES_GAIN)
	if(length(granted_traits))
		quirk_holder.remove_traits(granted_traits, QUIRK_TRAIT)
	if(QDELING(quirk_holder))
		return
	remove_biology()

/// The holder became a new species, which means a fresh species datum with none of our changes on it.
/datum/quirk/heritage/proc/on_species_gain(datum/source, datum/species/new_species, datum/species/old_species)
	SIGNAL_HANDLER
	// The new species datum never had our overrides, so what it has now is what we'd restore to.
	replaced_organ_types = null
	old_species_bloodtype = null
	apply_biology()

/**
 * Applies organs and blood to the holder and their species datum. Safe to call more than once.
 * Override for one-off behaviour, calling the parent.
 */
/datum/quirk/heritage/proc/apply_biology()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna?.species
	if(isnull(species))
		return

	for(var/slot in organ_overrides)
		var/obj/item/organ/new_type = organ_overrides[slot]
		var/obj/item/organ/species_type = species.get_mutant_organ_type_for_slot(slot)
		if(species_type != new_type)
			LAZYSET(replaced_organ_types, slot, species_type)
			species.set_mutant_organ_type_for_slot(slot, new_type)

		var/obj/item/organ/existing = human_holder.get_organ_slot(slot)
		if(existing?.type == new_type)
			continue
		var/obj/item/organ/new_organ = new new_type()
		if(existing)
			new_organ.copy_traits_from(existing)
		new_organ.Insert(human_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)

	if(exotic_bloodtype)
		old_bloodtype ||= human_holder.get_bloodtype()
		if(species.exotic_bloodtype != exotic_bloodtype)
			old_species_bloodtype = species.exotic_bloodtype
			species.exotic_bloodtype = exotic_bloodtype
		human_holder.set_blood_type(exotic_bloodtype)

/**
 * Undoes `apply_biology()`. Organs that were swapped out by something else since are left alone.
 * Override for one-off behaviour, calling the parent.
 */
/datum/quirk/heritage/proc/remove_biology()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna?.species
	if(isnull(species))
		return

	for(var/slot in replaced_organ_types)
		var/obj/item/organ/original_type = replaced_organ_types[slot]
		species.set_mutant_organ_type_for_slot(slot, original_type)

		var/obj/item/organ/existing = human_holder.get_organ_slot(slot)
		if(existing && existing.type != organ_overrides[slot])
			continue // Not ours anymore, someone transplanted something else in.
		if(isnull(original_type))
			existing?.Remove(human_holder, special = TRUE)
			qdel(existing)
			continue
		var/obj/item/organ/new_organ = new original_type()
		if(existing)
			new_organ.copy_traits_from(existing)
		new_organ.Insert(human_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)
	replaced_organ_types = null

	if(exotic_bloodtype)
		if(species.exotic_bloodtype == exotic_bloodtype)
			species.exotic_bloodtype = old_species_bloodtype
		if(old_bloodtype)
			human_holder.set_blood_type(old_bloodtype)
		old_bloodtype = null
		old_species_bloodtype = null

/**
 * Sets the organ type this species gives for the given slot. The counterpart of `get_mutant_organ_type_for_slot()`.
 * Passing null removes the organ from the species.
 */
/datum/species/proc/set_mutant_organ_type_for_slot(slot, obj/item/organ/organ_type)
	switch(slot)
		if(ORGAN_SLOT_BRAIN)
			mutantbrain = organ_type
		if(ORGAN_SLOT_HEART)
			mutantheart = organ_type
		if(ORGAN_SLOT_LUNGS)
			mutantlungs = organ_type
		if(ORGAN_SLOT_APPENDIX)
			mutantappendix = organ_type
		if(ORGAN_SLOT_EYES)
			mutanteyes = organ_type
		if(ORGAN_SLOT_EARS)
			mutantears = organ_type
		if(ORGAN_SLOT_TONGUE)
			mutanttongue = organ_type
		if(ORGAN_SLOT_LIVER)
			mutantliver = organ_type
		if(ORGAN_SLOT_STOMACH)
			mutantstomach = organ_type
		else
			// Non-standard organs. Copy before editing, the list may be shared with the species prototype.
			var/list/new_mutant_organs = LAZYCOPY(mutant_organs)
			for(var/obj/item/organ/extra_organ as anything in new_mutant_organs)
				if(initial(extra_organ.slot) == slot)
					new_mutant_organs -= extra_organ
			if(organ_type)
				new_mutant_organs += organ_type
			mutant_organs = new_mutant_organs
