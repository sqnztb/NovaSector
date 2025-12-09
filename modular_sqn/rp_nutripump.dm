//
//I'm just using this as an all in one solution to all the rp shenanigans
//
//
// Keeps your nutrition between 350-500
// Adds TRAIT_NOBREATH
//
//
/obj/item/organ/internal/cyberimp/chest/nutriment/sqnrp
	name = "Nutriment pump implant PLUS PLUS"
	desc = "It's even better than before. Hungry? Not any more. Too full? We take care of that, too."
	var/hunger_threshold_low = NUTRITION_LEVEL_FED
	var/hunger_threshold_high = NUTRITION_LEVEL_FULL

/*
/obj/item/organ/internal/cyberimp/chest/nutriment/sqnrp/on_insert(mob/living/carbon/owner)
	. = ..()
	ADD_TRAIT(owner, TRAIT_NOBREATH, ORGAN_TRAIT)
/obj/item/organ/internal/cyberimp/chest/nutriment/sqnrp/on_remove(mob/living/carbon/owner)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOBREATH, ORGAN_TRAIT)
*/
/obj/item/organ/internal/cyberimp/chest/nutriment/sqnrp/on_life(seconds_per_tick, times_fired)
	if(owner.nutrition <= hunger_threshold_low)
		owner.adjust_nutrition(100 * seconds_per_tick)
	if(owner.nutrition >= hunger_threshold_high - 50)
		owner.adjust_nutrition(-10 * seconds_per_tick)

/obj/item/organ/internal/cyberimp/chest/nutriment/sqnrp/emp_act(severity)
	. = ..()
	return

//Nutrition levels for humans
//#define NUTRITION_LEVEL_FAT 600
//#define NUTRITION_LEVEL_FULL 550
//#define NUTRITION_LEVEL_WELL_FED 450
//#define NUTRITION_LEVEL_FED 350
//#define NUTRITION_LEVEL_HUNGRY 250
//#define NUTRITION_LEVEL_STARVING 150

/obj/item/autosurgeon/sqnrp_pump
	desc = "Gives self-respiration and regulates your nutrition levels. I can't be bothered to write some gimmicky tagline for it."
	starting_organ = /obj/item/organ/internal/cyberimp/chest/nutriment/sqnrp
