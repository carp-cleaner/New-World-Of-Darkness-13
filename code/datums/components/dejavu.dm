/**
 * A component to reset the parent to its previous state after some time passes
 */
/datum/component/dejavu
	/// The turf the parent was on when this components was applied, they get moved back here after the duration
	var/turf/starting_turf
	/// Determined by the type of the parent so different behaviours can happen per type
	var/rewind_type
	/// How many rewinds will happen before the effect ends
	var/rewinds_remaining
	/// How long to wait between each rewind
	var/rewind_interval

	/// The starting value of clone loss at the beginning of the effect
	var/clone_loss = 0
	/// The starting value of toxin loss at the beginning of the effect
	var/tox_loss = 0
	/// The starting value of oxygen loss at the beginning of the effect
	var/oxy_loss = 0
	/// The starting value of brain loss at the beginning of the effect
	var/brain_loss = 0
	/// The starting value of brute loss at the beginning of the effect
	/// This only applies to simple animals
	var/brute_loss
	/// The starting value of integrity at the beginning of the effect
	/// This only applies to objects
	var/integrity
	/// A list of body parts saved at the beginning of the effect
	var/list/datum/saved_bodypart/saved_bodyparts
	var/last_move_dir
	var/move_timer

/datum/component/dejavu/Initialize(rewinds = 1, interval = 10 SECONDS)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	starting_turf = get_turf(parent)
	rewinds_remaining = rewinds
	rewind_interval = interval

	if(isliving(parent))
		var/mob/living/L = parent
		clone_loss = L.getCloneLoss()
		tox_loss = L.getToxLoss()
		oxy_loss = L.getOxyLoss()
		brain_loss = L.getOrganLoss(ORGAN_SLOT_BRAIN)
		rewind_type = PROC_REF(rewind_living)
		last_move_dir = L.last_move
		ADD_TRAIT(L, TRAIT_DEJAVU, "dejavu")
		ADD_TRAIT(L, TRAIT_MUTE, "dejavu")
		ADD_TRAIT(L, TRAIT_IMMOBILIZED, "dejavu")
		if(last_move_dir)
			move_timer = addtimer(CALLBACK(src, PROC_REF(force_move_loop)), 1 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)
		RegisterSignal(L, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damage))
		RegisterSignal(L, COMSIG_POWER_ACTIVATE_ON, PROC_REF(on_discipline_cast))

	if(iscarbon(parent))
		var/mob/living/carbon/C = parent
		saved_bodyparts = C.save_bodyparts()
		rewind_type = PROC_REF(rewind_carbon)

	else if(isanimal(parent))
		var/mob/living/simple_animal/M = parent
		brute_loss = M.bruteloss
		rewind_type = PROC_REF(rewind_animal)

	else if(isobj(parent))
		var/obj/O = parent
		integrity = O.obj_integrity
		rewind_type = PROC_REF(rewind_obj)

	addtimer(CALLBACK(src, rewind_type), rewind_interval)

/datum/component/dejavu/Destroy()
	if(isliving(parent))
		var/mob/living/L = parent
		REMOVE_TRAIT(L, TRAIT_DEJAVU, "dejavu")
		REMOVE_TRAIT(L, TRAIT_MUTE, "dejavu")
		REMOVE_TRAIT(L, TRAIT_IMMOBILIZED, "dejavu")
		UnregisterSignal(L, COMSIG_MOB_APPLY_DAMGE)
		UnregisterSignal(L, COMSIG_POWER_ACTIVATE_ON)
	deltimer(move_timer)
	starting_turf = null
	saved_bodyparts = null
	return ..()

/datum/component/dejavu/proc/rewind()
	to_chat(parent, "<span class=notice>You remember a time not so long ago...</span>")

	//comes after healing so new limbs comically drop to the floor
	if(starting_turf)
		var/area/destination_area = starting_turf.loc
		if(destination_area.area_flags & NOTELEPORT)
			to_chat(parent, "<span class='warning'>For some reason, your head aches and fills with mental fog when you try to think of where you were... It feels like you're now going against some dull, unstoppable universal force.</span>")
		else
			var/atom/movable/master = parent
			dejavu_visual_effect(master, power = 2)
			master.forceMove(starting_turf)
			dejavu_visual_effect(master, power = 3)

	rewinds_remaining --
	if(rewinds_remaining)
		addtimer(CALLBACK(src, rewind_type), rewind_interval)
	else
		to_chat(parent, "<span class=notice>But the memory falls out of your reach.</span>")
		qdel(src)

/datum/component/dejavu/proc/rewind_living()
	var/mob/living/master = parent
	master.setCloneLoss(clone_loss)
	master.setToxLoss(tox_loss)
	master.setOxyLoss(oxy_loss)
	master.setOrganLoss(ORGAN_SLOT_BRAIN, brain_loss)
	rewind()

/datum/component/dejavu/proc/rewind_carbon()
	if(saved_bodyparts)
		var/mob/living/carbon/master = parent
		master.apply_saved_bodyparts(saved_bodyparts)
	rewind_living()

/datum/component/dejavu/proc/rewind_animal()
	var/mob/living/simple_animal/master = parent
	master.bruteloss = brute_loss
	master.updatehealth()
	rewind_living()

/datum/component/dejavu/proc/rewind_obj()
	var/obj/master = parent
	master.obj_integrity = integrity
	rewind()

/datum/component/dejavu/proc/force_move_loop()
	var/mob/living/L = parent
	if(!last_move_dir)
		return
	dejavu_visual_effect(L)
	step(L, last_move_dir) //

/datum/component/dejavu/proc/dejavu_visual_effect(mob/living/L, power = 1)
	var/glitch_range = 3 * power
	var/afterimage_range = 8 * power
	var/afterimage_count = power
	var/matrix/initial_matrix = matrix(L.transform)
	var/matrix/glitch1 = matrix(L.transform)
	var/matrix/glitch2 = matrix(L.transform)
	glitch1.Translate(rand(-glitch_range, glitch_range), rand(-glitch_range/3, glitch_range/3))
	glitch2.Translate(rand(-glitch_range/3, glitch_range/3), rand(-glitch_range, glitch_range))
	animate(L, transform = glitch1, time = 0.2 SECONDS, loop = 0)
	animate(transform = glitch2, time = 0.2 SECONDS, loop = 0)
	animate(transform = initial_matrix, time = 0.3 SECONDS, loop = 0, easing = SINE_EASING)
	for(var/i in 1 to afterimage_count)
		spawn(i * 0.1 SECONDS)
			var/obj/effect/temporis/afterimage = new(L.loc)
			afterimage.name = L.name
			afterimage.appearance = L.appearance
			afterimage.dir = L.dir
			afterimage.color = "#aaccff"
			animate(afterimage, pixel_x = rand(-afterimage_range, afterimage_range), pixel_y = rand(-afterimage_range, afterimage_range), alpha = 0, time = 0.8 SECONDS)

/datum/component/dejavu/proc/on_damage(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damage > 0)
		break_free()

/datum/component/dejavu/proc/on_discipline_cast(datum/source, datum/discipline_power/power, atom/target)
	SIGNAL_HANDLER
	break_free()

/datum/component/dejavu/proc/break_free()
	qdel(src)
