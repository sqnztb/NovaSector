#define SQN_HYPO_REAGENTS list(\
		/datum/reagent/drug/aphrodisiac/crocin/hexacrocin,\
		/datum/reagent/drug/aphrodisiac/crocin,\
		/datum/reagent/drug/aphrodisiac/succubus_milk,\
		/datum/reagent/drug/aphrodisiac/incubus_draft,\
		/datum/reagent/drug/aphrodisiac/camphor,\
		/datum/reagent/drug/aphrodisiac/camphor/pentacamphor,\
		/datum/reagent/drug/aphrodisiac/dopamine,\
		/datum/reagent/medicine/pen_acid,\
		/datum/reagent/medicine/epinephrine,\
		/datum/reagent/medicine/syndicate_nanites\
	)

/obj/item/reagent_containers/borghypo/sqn
	default_reagent_types = SQN_HYPO_REAGENTS
	name = "Red Lily Hypospray"
	desc = "A hypospray unit with selectable outputs. It's got the initials \"NJ\" engraved onto the handle."
	possible_transfer_amounts = list(2,5,10,20)
	icon_state = "hypo"

/obj/item/reagent_containers/borghypo/sqn/attack(mob/living/carbon/injectee, mob/user)
	if(!istype(injectee))
		return
	if(!selected_reagent)
		balloon_alert(user, "no reagent selected!")
		return
	if(!stored_reagents.has_reagent(selected_reagent.type, amount_per_transfer_from_this))
		balloon_alert(user, "not enough [selected_reagent.name]!")
		return

	if(injectee.try_inject(user, user.zone_selected, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE | (bypass_protection ? INJECT_CHECK_PENETRATE_THICK : 0)))
		// This is the in-between where we're storing the reagent we're going to inject the injectee with
		// because we cannot specify a singular reagent to transfer in trans_to
		var/datum/reagents/hypospray_injector = new()
		//stored_reagents.remove_reagent(selected_reagent.type, amount_per_transfer_from_this)
		hypospray_injector.add_reagent(selected_reagent.type, amount_per_transfer_from_this, reagtemp = dispensed_temperature, no_react = TRUE)

		to_chat(injectee, span_warning("You feel a tiny prick!"))
		to_chat(user, span_notice("You inject [injectee] with the injector ([selected_reagent.name])."))

		if(injectee.reagents)
			hypospray_injector.trans_to(injectee, amount_per_transfer_from_this, transferred_by = user, methods = INJECT)
			balloon_alert(user, "[amount_per_transfer_from_this] unit\s injected")
			log_combat(user, injectee, "injected", src, "(CHEMICALS: [selected_reagent])")
	else
		balloon_alert(user, "[parse_zone(user.zone_selected)] is blocked!")

/obj/item/reagent_containers/hypospray/redlily
	name = "Red Lily Hypospray"
	desc = "A hypospray with a handwritten label taped to it that reads: \"Use with extreme caution. May have permanent effects.\""
	infinite = TRUE
	list_reagents = list(/datum/reagent/drug/aphrodisiac/redlily = 20)
	amount_per_transfer_from_this = 20

/datum/reagent/drug/aphrodisiac/redlily
	name = "Red Lily"
	description = "An extremely potent aphrodesiac that is considered an order of magnitude stronger than hexacrocin with fewer side effects. Impossible to synthesize under normal conditions. Extremely long lasting."
	taste_description = "strawberries"
	color = "#ff00ff"
	life_pref_datum = /datum/preference/toggle/erp/aphro
	arousal_adjust_amount = 0
	pleasure_adjust_amount = 0
	pain_adjust_amount = 0
	metabolization_rate = 0.01


/datum/reagent/drug/aphrodisiac/redlily/life_effects(mob/living/carbon/human/exposed_mob)
	//exposed_mob.adjust_arousal(arousal_adjust_amount)
	//exposed_mob.adjust_pleasure(pleasure_adjust_amount)
	//exposed_mob.adjust_pain(pain_adjust_amount)

	var/modified_genitals = FALSE
	for(var/obj/item/organ/external/genital/mob_genitals in exposed_mob.organs)
		if(!mob_genitals.aroused == AROUSAL_CANT)
			mob_genitals.aroused = AROUSAL_FULL
			mob_genitals.update_sprite_suffix()
			modified_genitals = TRUE
	if (modified_genitals)
		exposed_mob.update_body()
	switch(current_cycle)
		if(90 to 360)
			exposed_mob.adjustStaminaLoss(100)
	switch(current_cycle)
		if(1)
			to_chat(exposed_mob, span_purple("A warmth begins to spread throughout your body, starting at your groin. You begin to shiver, and the hair on your body stands on end. A small red circle forms around the injection site. You prod it a couple of times with your finger. It's almost hot to the touch.")) //add moodlet
		if(30)
			to_chat(exposed_mob, span_purple("Your muscles begin to weaken. You let out a tired sigh. Your body feels like you've not slept in ages. Your eyelids become heavy, as if being pulled down by some unknown force. Your mental faculties oddly remain intact as it feels like you're moving in slow motion. Your breathing begins to slow even as your heart rate begins to pick up."))
			exposed_mob.manual_emote("lets out a long, tired sigh.")
		if(60)
			to_chat(exposed_mob, span_purple("Your entire body starts to ache as the warmth that spread through you previously starts to flare up. It's getting very warm. Your clothes feel like they're binding, constricting you."))
			exposed_mob.emote("blush")
		if(90)
			to_chat(exposed_mob, span_purple("All across your body, your muscles begin to fail. You're suddenly exhausted. You groan and collapse to the floor as your body can no longer keep you standing. Your body starts to produce adrenaline to counteract it, but the drug has taken hold on you. You start to experience a massive fight or flight response.")) // apply stamina drain
			exposed_mob.manual_emote("groans softly, collapsing to the floor.")
		if(120)
			to_chat(exposed_mob, span_danger(span_big("An intense pressure forms in your head. A jolt of pain sears your mind, causing you to spasm.")))
			exposed_mob.manual_emote("suddenly spasms in pain!")
			exposed_mob.add_mood_event("redlily", /datum/mood_event/redlily1) // pain bad
		if(150)
			to_chat(exposed_mob, span_hypnophrase(span_reallybig("You feel your grip on yourself slipping. Something is forcing itself upon your psyche.")))
			to_chat(exposed_mob, span_purple("A small fragment inserts itself into your mind. "))
		if(180)
			to_chat(exposed_mob, span_danger(span_reallybig("The pain flows across your entire body. It's excruciating.")))
			to_chat(exposed_mob, span_danger("Every muscle in your body tenses up. You tremble from head to toe as every nerve goes haywire, sending massive amounts of mixed signals to your head. Tears start to form and fall down your cheeks."))
			exposed_mob.manual_emote("trembles all over as tears start to flow down their face. It looks agonizing.")
			exposed_mob.add_mood_event("redlily", /datum/mood_event/redlily2) // pain worse
		if(210)
			to_chat(exposed_mob, span_purple("You hear quiet whispers. They sound familiar. The pain that's been wracking your body starts to fade away. The sounds in your head become more clear. It's the sound of a female voice far in the distance, singing softly. You stop crying, but your eyes can't seem to keep focus on anything."))
			exposed_mob.manual_emote("stares off into the distance.")
		if(240)
			to_chat(exposed_mob, span_hypnophrase("The image of Nina-Jay flashes across in your mind. It's blurry and foggy, but you can make her out. The image flickers a few times, growing clearer each time until she's fully in focus. She's smiling. You can't help but smile back."))
			exposed_mob.manual_emote("smiles softly.")
			exposed_mob.add_mood_event("redlily", /datum/mood_event/redlily3) // no pain? first happy mood
		if(270)
			to_chat(exposed_mob, span_purple("A pleasant calmness washes over your body. You still can't move, but at this point you're not sure that you want to. You're content to just lay here, relaxing wherever it may be."))
		if(300)
			to_chat(exposed_mob, span_purple("All external sounds fade away. It's eerily quiet, but serene. The singing which you heard earlier is the only thing that you can hear for now. Each note sung flows through you, infusing you with a warmth in your chest. Your heart pounds with excitement. With each pump, you feel the rush of blood throughout your body.")) //apply deafen
		if(330)
			to_chat(exposed_mob, span_purple("A voice sounds out in the silence. It whispers quietly to you, words that are both happy and sad at the same time. \"I love you,\" she whispers to you. Your lips and throat move on their own, without any input from your mind. She repeats several more times. \"I love you, I love you, I love you...\""))
			exposed_mob.manual_emote("whispers softly, \"I love you too...\"")
		if(360)
			to_chat(exposed_mob, span_purple("Sounds slowly start to come back to you. It starts with a low ringing in your ears which fades over a few seconds as your hearing returns. The strength which had left your muscles previously rapidly returns to you. You feel invigorated."))
			exposed_mob.adjustStaminaLoss(-100)
		if(390)
			to_chat(exposed_mob, span_purple(span_big("She is with you now. You can feel her presence. Every bone, every muscle in your body, every beat of your heart. It all exsists now for one reason: for her. She lives to serve you, and you will live to serve her. You feel as if you've been given new meaning in life."))) //add moodlet
			exposed_mob.add_mood_event("redlily", /datum/mood_event/redlily4) // ultrahappy
	..()


/datum/mood_event/redlily1
	description = "Argh! My head! It hurts!"
	mood_change = -10

/datum/mood_event/redlily2
	description = "This pain is unbearable!"
	mood_change = -20

/datum/mood_event/redlily3
	description = "The pain is gone... I can see her smiling now."
	mood_change = 10

/datum/mood_event/redlily4
	description = "I have a purpose now. She is my purpose. I will devote everything to her."
	mood_change = 50
