/datum/chi_discipline/tapestry
	name = "Tapestry"
	desc = "Kuei-jin can manipulate the dragon lines that flow beneath the Middle Kingdom."
	icon_state = "tapestry"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1
	cost_yin = 1
	discipline_type = "Chi"
	activate_sound = 'code/modules/wod13/sounds/tapestry.ogg'
	var/prev_z
	var/totem_targeting = FALSE


/obj/penumbra_ghost
	var/last_umbra_move

/obj/penumbra_ghost/relaymove(mob/living/user, direction)
	if(last_umbra_move+5 < world.time)
		last_umbra_move = world.time
		dir = direction
		forceMove(get_step(src, direction))


/obj/effect/anomaly/grav_kuei
	name = "gravitational anomaly"
	icon_state = "shield2"
	density = FALSE
	var/boing = 0
	aSignal = /obj/item/assembly/signaler/anomaly/grav
	drops_core = FALSE
	var/mob/owner

/obj/effect/anomaly/grav_kuei/process(delta_time)
	anomalyEffect()		//so it's kinda more faster?
	if(death_time < world.time)
		if(loc)
			detonate()
		qdel(src)

/obj/effect/anomaly/grav_kuei/anomalyEffect()
	..()
	boing = TRUE
	for(var/obj/affected_object in orange(4, src))
		if(!affected_object.anchored)
			step_towards(affected_object, src)

	for(var/mob/living/affected_mob in (range(0, src) - owner))
		gravShock(affected_mob)

	for(var/mob/living/affected_mob in (orange(4, src) - owner))
		if(!affected_mob.mob_negates_gravity())
			step_towards(affected_mob, src)

	for(var/obj/affected_object in range(0, src))
		if(!affected_object.anchored)
			if(isturf(affected_object.loc))
				var/turf/object_turf = affected_object.loc
				if(object_turf.intact && HAS_TRAIT(affected_object, TRAIT_T_RAY_VISIBLE))
					continue
			var/mob/living/target = locate() in view(4,src) - owner
			if(target && !target.stat)
				affected_object.throw_at(target, 5, 10)

/obj/effect/anomaly/grav_kuei/Crossed(atom/movable/AM)
	. = ..()
	gravShock(AM)

/obj/effect/anomaly/grav_kuei/Bump(atom/A)
	gravShock(A)

/obj/effect/anomaly/grav_kuei/Bumped(atom/movable/AM)
	gravShock(AM)

/obj/effect/anomaly/grav_kuei/proc/gravShock(mob/living/affected_mob)
	if(boing && isliving(affected_mob) && !affected_mob.stat)
		affected_mob.Paralyze(4 SECONDS)
		var/atom/target = get_edge_target_turf(affected_mob, get_dir(src, get_step_away(affected_mob, src)))
		affected_mob.throw_at(target, 5, 1)
		boing = FALSE

/datum/chi_discipline/tapestry/check_activated(mob/living/target, mob/living/carbon/human/caster)
	if(level_casting == 2 || level_casting == 4)
		if(caster.stat >= HARD_CRIT || caster.IsSleeping() || caster.IsUnconscious() || caster.IsParalyzed() || caster.IsStun() || HAS_TRAIT(caster, TRAIT_RESTRAINED))
			return FALSE
		if(level_casting == 2 && totem_targeting)
			return TRUE
		if(caster.yin_chi < cost_yin)
			SEND_SOUND(caster, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
			to_chat(caster, "<span class='warning'>You don't have enough <b>Yin Chi</b> to use [src].</span>")
			return FALSE
		if(caster.yang_chi < cost_yang)
			SEND_SOUND(caster, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
			to_chat(caster, "<span class='warning'>You don't have enough <b>Yang Chi</b> to use [src].</span>")
			return FALSE
		return TRUE
	return ..()

/datum/chi_discipline/tapestry/activate(mob/living/target, mob/living/carbon/human/caster)
	if(level_casting == 2)
		if(totem_targeting)
			UnregisterSignal(caster, COMSIG_MOB_CLICKON)
			totem_targeting = FALSE
			to_chat(caster, "<span class='warning'>You cancel the Dragon Gate ritual.</span>")
			return
		to_chat(caster, "<span class='notice'>Use the totem to open or close the Dragon Gate.</span>")
		totem_targeting = TRUE
		RegisterSignal(caster, COMSIG_MOB_CLICKON, PROC_REF(handle_totem_click))
		return

	if(level_casting == 4)
		var/list/portal_destinations = list()
		for(var/obj/structure/werewolf_totem/W in GLOB.totems)
			if(W.totem_health > 0)
				var/obj/umbra_portal/portal = locate() in get_step(W, SOUTH)
				if(portal?.exit)
					portal_destinations["[W.name] ([W.tribe])"] = portal
		if(!length(portal_destinations))
			to_chat(caster, "<span class='warning'>You sense no open Dragon Lines...</span>")
			return
		var/choice = input(caster, "Choose a Dragon Gate to travel to:", "Dragon Lines") as null|anything in portal_destinations
		if(!choice)
			return
		var/obj/umbra_portal/chosen_portal = portal_destinations[choice]
		if(QDELETED(chosen_portal))
			to_chat(caster, "<span class='warning'>The Dragon Gate has closed!</span>")
			return
		if(do_mob(caster, caster, delay))
			caster.yin_chi = max(0, caster.yin_chi - cost_yin)
			caster.yang_chi = max(0, caster.yang_chi - cost_yang)
			caster.update_chi_hud()
			var/datum/effect_system/smoke_spread/smoke = new
			smoke.set_up(2, caster.loc)
			smoke.attach(caster)
			smoke.start()
			caster.forceMove(get_turf(chosen_portal))
			playsound(get_turf(caster), 'code/modules/wod13/sounds/portal.ogg', 75, FALSE)
		return

	..()
	switch(level_casting)
		if(1)
			caster.client.prefs.chat_toggles ^= CHAT_DEAD
			var/datum/atom_hud/ghost_hud = GLOB.huds[DATA_HUD_GHOST]
			ghost_hud.add_hud_to(caster)
			notify_ghosts("All ghosts are being called by [caster]!", source = caster, action = NOTIFY_ORBIT, header = "Ghost Summoning")
			spawn(30 SECONDS)
				if(caster)
					caster.client?.prefs.chat_toggles &= ~CHAT_DEAD
					ghost_hud.remove_hud_from(caster)
		if(3)
			ADD_TRAIT(caster, TRAIT_SUPERNATURAL_LUCK, "tapestry 3")
			to_chat(caster, "<b>You feel insanely lucky!</b>")
			spawn(30 SECONDS)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_SUPERNATURAL_LUCK, "tapestry 3")
					to_chat(caster, "<span class='warning'>Your luck wanes...</span>")
		if(5)
			var/obj/effect/anomaly/grav_kuei/grav_anomaly = new (get_turf(caster))
			grav_anomaly.owner = caster
			spawn(30 SECONDS)
				qdel(grav_anomaly)

/datum/chi_discipline/tapestry/proc/handle_totem_click(mob/source, atom/clicked, click_parameters)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(click_parameters)
	var/mob/living/carbon/human/caster = source

	if(modifiers["right"])
		UnregisterSignal(source, COMSIG_MOB_CLICKON)
		totem_targeting = FALSE
		to_chat(source, "<span class='warning'>You cancel the Dragon Gate ritual.</span>")
		return COMSIG_MOB_CANCEL_CLICKON

	if(!istype(clicked, /obj/structure/werewolf_totem))
		return

	var/obj/structure/werewolf_totem/totem = clicked

	if(!caster.Adjacent(totem))
		to_chat(caster, "<span class='warning'>You need to be closer to the totem!</span>")
		return COMSIG_MOB_CANCEL_CLICKON

	if(totem.totem_health <= 0)
		to_chat(caster, "<span class='warning'>[totem] is broken!</span>")
		return COMSIG_MOB_CANCEL_CLICKON

	UnregisterSignal(source, COMSIG_MOB_CLICKON)
	totem_targeting = FALSE

	var/obj/umbra_portal/prev = locate() in get_step(totem, SOUTH)
	if(prev)
		caster.yin_chi = max(0, caster.yin_chi - cost_yin)
		caster.yang_chi = max(0, caster.yang_chi - cost_yang)
		caster.update_chi_hud()
		playsound(totem.loc, 'code/modules/wod13/sounds/portal.ogg', 75, FALSE)
		qdel(prev.exit)
		qdel(prev)
		to_chat(caster, "<span class='notice'>You close the Dragon Gate.</span>")
		return COMSIG_MOB_CANCEL_CLICKON

	if(!totem.teleport_turf)
		to_chat(caster, "<span class='warning'>This totem has no destination linked!</span>")
		return COMSIG_MOB_CANCEL_CLICKON

	if(totem.opening)
		return COMSIG_MOB_CANCEL_CLICKON

	totem.opening = TRUE
	spawn()
		if(do_mob(caster, totem, delay))
			caster.yin_chi = max(0, caster.yin_chi - cost_yin)
			caster.yang_chi = max(0, caster.yang_chi - cost_yang)
			caster.update_chi_hud()
			playsound(totem.loc, 'code/modules/wod13/sounds/portal.ogg', 75, FALSE)
			var/obj/umbra_portal/U = new (get_step(totem, SOUTH))
			U.id = "[totem.tribe][rand(1, 999)]"
			U.later_initialize()
			var/obj/umbra_portal/P = new (totem.teleport_turf)
			P.id = U.id
			P.later_initialize()
			to_chat(caster, "<span class='notice'>You open the Dragon Gate!</span>")
		totem.opening = FALSE
	return COMSIG_MOB_CANCEL_CLICKON
