//! WARNING !//
// Restructurized disces into separate files
// Find here: code/modules/vtmb/disciplines
// I'll not remove it 'cause i DO NOT FUCKING UNDERSTAND where to put it


GLOBAL_LIST_EMPTY(who_is_cursed)

/turf
	var/silented = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel
	name = "Gangrel Form"
	desc = "Take on the shape a wolf."
	charge_max = 50
	cooldown_min = 50
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/gangrel

/*
/datum/discipline/bloodshield
	name = "Blood shield"
	desc = "Boosts armor."
	icon_state = "bloodshield"
	cost = 2
	ranged = FALSE
	delay = 150
	activate_sound = 'code/modules/wod13/sounds/thaum.ogg'

/datum/discipline/bloodshield/activate(mob/living/target, mob/living/carbon/human/caster)
	..()
	var/mod = level_casting
	caster.physiology.armor.melee = caster.physiology.armor.melee+(15*mod)
	caster.physiology.armor.bullet = caster.physiology.armor.bullet+(15*mod)
	animate(caster, color = "#ff0000", time = 10, loop = 1)
//	caster.color = "#ff0000"
	spawn(delay+caster.discipline_time_plus)
		if(caster)
			playsound(caster.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
			caster.physiology.armor.melee = caster.physiology.armor.melee-(15*mod)
			caster.physiology.armor.bullet = caster.physiology.armor.bullet-(15*mod)
			caster.color = initial(caster.color)
*/

