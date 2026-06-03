/datum/curse/daimonion
	//Minimum gen required to unlock the curse
	var/genrequired
	//Amount of blood to permanently tithe
	var/bloodcurse = 1

/datum/curse/daimonion/proc/activate(mob/living/target)
	to_chat(target, span_userdanger(span_bold("You feel like a great infernal curse was placed upon you!")))
	return

/datum/curse/daimonion/lying_weakness
	name = "No Lying Tongue"
	genrequired = 13

/datum/curse/daimonion/physical_weakness
	name = "Baby Strength"
	genrequired = 12
	bloodcurse = 2

/datum/curse/daimonion/mental_weakness
	name = "Reap Mentality"
	genrequired = 11
	bloodcurse = 3

/datum/curse/daimonion/offspring_weakness
	name = "Sterile Vitae"
	genrequired = 9
	bloodcurse = 4

/datum/curse/daimonion/success_weakness
	name = "The Mark Of Doom"
	genrequired = 7
	bloodcurse = 5

/datum/curse/daimonion/lying_weakness/activate(mob/living/target)
	. = ..()
	ADD_TRAIT(target, TRAIT_LYING_WEAKNESS, DISCIPLINE_TRAIT)

/datum/curse/daimonion/physical_weakness/activate(mob/living/target)
	. = ..()
	if(get_a_strength(target) > 0)
		target.attributes.strength -= 1
	if(get_a_dexterity(target) > 0)
		target.attributes.dexterity -= 1
	if(get_a_stamina(target) > 0)
		target.attributes.stamina -= 1
	if(get_a_athletics(target) > 0)
		target.attributes.Athletics -= 1
	if(get_a_brawl(target) > 0)
		target.attributes.Brawl -= 1
	if(get_a_melee(target) > 0)
		target.attributes.Melee -= 1
	if(iskindred(target))
		for(var/datum/action/blood_power/blood_power in target.actions)
			if(blood_power)
				blood_power.Remove(target)

/datum/curse/daimonion/mental_weakness/activate(mob/living/target)
	. = ..()
	if(get_a_charisma(target) > 0)
		target.attributes.charisma -= 1
	if(get_a_manipulation(target) > 0)
		target.attributes.manipulation -= 1
	if(get_a_appearance(target) > 0)
		target.attributes.appearance -= 1
	if(get_a_perception(target) > 0)
		target.attributes.perception -= 1
	if(get_a_intelligence(target) > 0)
		target.attributes.intelligence -= 1
	if(get_a_wits(target) > 0)
		target.attributes.wits -= 1
	if(get_a_alertness(target) > 0)
		target.attributes.Alertness -= 1
	if(get_a_expression(target) > 0)
		target.attributes.Expression -= 1

/datum/curse/daimonion/offspring_weakness/activate(mob/living/target)
	. = ..()
	for(var/datum/action/give_vitae/give_vitae in target.actions)
		give_vitae.Remove(target)

/datum/curse/daimonion/success_weakness/activate(mob/living/target)
	. = ..()
	target.attributes.diff_curse += 1
