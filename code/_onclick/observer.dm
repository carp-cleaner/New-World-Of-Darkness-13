/*/mob/dead/observer/DblClickOn(atom/A, params)
	//if(check_click_intercept(params, A))
		//return

	if(can_reenter_corpse && mind?.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (body bag, closet, mech, etc)

	else		//return	[Lucifernix] - Removing the thing where ghosts can't double click. This was below reenter_corpse()						// seems legit.
		forceMove(get_turf(A))
		update_parallax_contents()
	// Things you might plausibly want to follow

	// [ChillRaccoon] - follow and teleport should make only admins

	if(!aghosted)
		return FALSE

	if(ismovable(A))					[Lucifernix] - All this code has a bug where jumping into dark spaces makes your screen dark. Needs fixing before allowing this.
		ManualFollow(A)

	// Otherwise jump
	//else if(A.loc)
*/

/mob/dead/observer/ClickOn(atom/A, params)
	if(check_click_intercept(params,A))
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["middle"])
		ShiftMiddleClickOn(A)
		return
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"])
		AltClickNoInteract(src, A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(world.time <= next_move)
		return
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below

	if(istype(loc, /obj/item) && lastattack <= world.time)
		lastattack = world.time+1 SECONDS
		var/obj/item/I = loc
		I.throw_at(get_turf(A), rand(2, 4), 5, src)

	if(get_dist(src, A) <= 1)
		if(isclosedturf(A))
			if(corpus > 1)
				var/phasethrough = alert(src, "Do you wish to spend your corpus to pass this wall?", "Phase Through", "Yes", "No")
				if(phasethrough == "Yes")
					damage_corpus()
					forceMove(A)
		if(isliving(A))
			var/mob/living/L = A
			if(!L.key)
				to_chat(src, "<span class='warning'>[A] seems to ignore you, like you're invisible...")
				return
			if(invisibility == 0 && lastattack <= world.time)
				do_attack_animation(A)
				lastattack = world.time+5 SECONDS
				L.apply_damage(10, CLONE, BODY_ZONE_CHEST, wound_bonus=CANT_WOUND)
				if(L == lastattacker)
					if(passion == "revenge")
						restore_pathos()
				for(var/mob/M in viewers(7, src))
					if(M)
						to_chat(M, "<span class='warning'>[src] tears through [A]'s flesh...")
		if(istype(A, /obj/structure/vampdoor))
			var/obj/structure/vampdoor/V = A
			if(!V.locked)
				if(!acting)
					acting = TRUE
					spawn(0.5 SECONDS)
						acting = FALSE
						if(V.closed)
							playsound(V, V.open_sound, 75, TRUE)
							V.icon_state = "[V.baseicon]-0"
							V.density = FALSE
							V.opacity = FALSE
							V.layer = OPEN_DOOR_LAYER
							to_chat(src, "<span class='notice'>You open [V].</span>")
							V.closed = FALSE
						else
							for(var/mob/living/L in V.loc)
								if(L)
									playsound(src, V.lock_sound, 75, TRUE)
									to_chat(src, "<span class='warning'>[L] is preventing you from closing [V].</span>")
									return
							playsound(V, V.close_sound, 75, TRUE)
							V.icon_state = "[V.baseicon]-1"
							V.density = TRUE
							if(!V.glass)
								V.opacity = TRUE
							V.layer = ABOVE_ALL_MOB_LAYER
							to_chat(src, "<span class='notice'>You close [V].</span>")
							V.closed = TRUE
			else
				V.pixel_z = V.pixel_z+rand(-1, 1)
				V.pixel_w = V.pixel_w+rand(-1, 1)
				playsound(V, 'code/modules/wod13/sounds/knock.ogg', 75, TRUE)
				to_chat(src, "<span class='warning'>[V] is locked!</span>")
				spawn(2)
					V.pixel_z = initial(V.pixel_z)
					V.pixel_w = initial(V.pixel_w)
		if(istype(A, /obj/manholeup))
			if(!acting)
				acting = TRUE
				spawn(0.5 SECONDS)
					acting = FALSE
					var/turf/destination = get_step_multiz(A, UP)
					forceMove(destination)
					playsound(A, 'code/modules/wod13/sounds/manhole.ogg', 50, TRUE)
		if(istype(A, /obj/manholedown))
			if(!acting)
				acting = TRUE
				spawn(0.5 SECONDS)
					acting = FALSE
					var/turf/destination = get_step_multiz(A, DOWN)
					forceMove(destination)
					playsound(A, 'code/modules/wod13/sounds/manhole.ogg', 50, TRUE)

	A.attack_ghost(src)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/dead/observer/user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_GHOST, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(user.client)
		if(user.gas_scan && atmosanalyzer_scan(user, src))
			return TRUE
		else if(isAdminGhostAI(user))
			attack_ai(user)
		else if(user.client.prefs.inquisitive_ghost)
			user.examinate(src)
	return FALSE

/mob/living/attack_ghost(mob/dead/observer/user)
	if(user.client && user.health_scan)
		healthscan(user, src, 1, TRUE)
	if(user.client && user.chem_scan)
		chemscan(user, src)
	return ..()

// ---------------------------------------
// And here are some good things for free:
// Now you can click through portals, wormholes, gateways, and teleporters while observing. -Sayu

/obj/effect/gateway_portal_bumper/attack_ghost(mob/user)
	if(gateway)
		gateway.Transfer(user)
	return ..()

/obj/machinery/teleport/hub/attack_ghost(mob/user)
	if(power_station?.engaged && power_station.teleporter_console && power_station.teleporter_console.target)
		user.forceMove(get_turf(power_station.teleporter_console.target))
	return ..()
