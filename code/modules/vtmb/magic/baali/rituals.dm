/datum/rune_ritual
	var/name = "Ritual Name"
	var/description = "Ritual Description"
	var/cost = 1
	var/category = "Unsorted"

/datum/rune_ritual/proc/Initialize()
	return TRUE

/datum/rune_ritual/proc/Execute(mob/user, obj/effect/decal/baalirune/rune)
	return FALSE

/datum/rune_ritual/infernal_servitor
	name = "Infernal Servitor"
	description = "Summon a demon to serve you"
	cost = 20
	category = "Servers"

/datum/rune_ritual/infernal_servitor/Execute(mob/user, obj/effect/decal/baalirune/rune)
	playsound(get_turf(rune), 'sound/magic/demon_dies.ogg', 100, TRUE)
	new /mob/living/simple_animal/hostile/baali_guard(get_turf(rune))
	//var/datum/preferences/P = GLOB.preferences_datums[ckey(user.key)]
	//(P)
	//P.exper = min(calculate_mob_max_exper(user), P.exper+15)
	return TRUE
