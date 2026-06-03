
/atom/movable/screen/ghost
	icon = 'code/modules/wod13/UI/buttons32.dmi'
	icon_state = "wraith_template"
	plane = 45 // [ChillRaccoon] - 42 was a value by default
	var/pathos_req = 0
	var/psyche_min = 0
	var/mob/dead/observer/G
	var/last_activate = 0
	var/usable = FALSE
	var/nocorpus = FALSE
/*
/atom/movable/screen/ghost/MouseEntered()
	flick(icon_state + "_anim", src)
*/

/atom/movable/screen/ghost/Click()
	if(!G)
		G = usr
		G.update_psyche()
	if(!usable)
		return FALSE
	if(G.corpus == 0)
		if(!nocorpus)
			to_chat(G, "<span class='warning'>You lost all of your corpus!</span>")
			return FALSE
	if((G.lastslumber > world.time) || (G.lastcorpusdamage > world.time))
		to_chat(G, "<span class='warning'>You can't use this arcanoi right now.</span>")
		return FALSE
	if(last_activate > world.time)
		to_chat(G, "<span class='warning'>It's too early!</span>")
		return FALSE
	if(G.psyche < psyche_min)
		to_chat(G, "<span class='warning'>Connection with your Psyche is too low. Being near your fetters and anchors would raise it.</span>")
		return FALSE
	if(G.pathos < pathos_req)
		to_chat(G, "<span class='warning'>You don't have enough Pathos. Try slumbering for a minute.</span>")
		return FALSE
	last_activate = world.time+15 SECONDS
	G.pathos = max(0, G.pathos-pathos_req)
	G.update_psyche()
	to_chat(G, "<span class='notice'>You activate [name]</span>")
	return TRUE

/atom/movable/screen/ghost/jumptomob
	name = "Jump to mob"
	icon_state = "jumptomob"
	usable = TRUE

/atom/movable/screen/ghost/jumptomob/Click()
	if(..())
		G.jumptomob()

/atom/movable/screen/ghost/orbit
	name = "Orbit"
	icon_state = "orbit"
	usable = TRUE

/atom/movable/screen/ghost/orbit/Click()
	if(..())
		G.follow()

/atom/movable/screen/ghost/reenter_corpse
	name = "Reenter corpse"
	icon_state = "reenter_corpse"
	usable = TRUE

/atom/movable/screen/ghost/reenter_corpse/Click()
	if(..())
		G.reenter_corpse()

/atom/movable/screen/ghost/teleport
	name = "Teleport"
	icon_state = "teleport"
	pathos_req = 2
	psyche_min = 2
	usable = TRUE

/atom/movable/screen/ghost/teleport/Click()
	if(..())
		G.dead_tele()

/atom/movable/screen/ghost/pai
	name = "pAI Candidate"
	icon_state = "pai"
	usable = TRUE

/atom/movable/screen/ghost/pai/Click()
	if(..())
		G.register_pai()

/atom/movable/screen/ghost/respawn
	name = "Respawn"
	icon_state = "respawn"
	usable = TRUE
	nocorpus = TRUE

/atom/movable/screen/ghost/respawn/Click()
	if(..())
		G.abandon_mob()

/atom/movable/screen/ghost/keening
	name = "Keening"
	icon_state = "keening"
	pathos_req = 1
	psyche_min = 1
	usable = TRUE

/atom/movable/screen/ghost/keening/Click()
	if(..())
		var/msg = input("Message:", text("Enter the text you wish to appear to everyone within view:")) as text|null
		msg = trim(copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN))
		if (!msg)
			return
		for(var/mob/M in view(7,G))
			to_chat(M, "<b>distant voice</b> says, \"<span class='hypnophrase'>[msg]</span>\"")

/atom/movable/screen/ghost/slumber
	name = "Slumber"
	icon_state = "slumber"
	pathos_req = 1
	usable = TRUE

/mob/dead/observer
	var/damaged_when_slumber = FALSE
	var/slumbercooldown = 0
	var/list/exploredareas = list()

/atom/movable/screen/ghost/slumber/Click()
	if(!G)
		G = usr
	if(G.slumbercooldown >= world.time)
		to_chat(G, "<span class='warning'>You can't slumber that quickly after loosing corpus!</span>")
	if(..())
		G.damaged_when_slumber = FALSE
		G.lastslumber = world.time + 1 MINUTES
		var/matrix/M = matrix()
		M.Turn(90)
		G.transform = M
		G.lastangst = world.time
		spawn(1 MINUTES)
			if(!G.damaged_when_slumber)
				G.transform = null
				G.corpus = min(10, G.corpus+max(1, G.psyche))
				if(G.relic)
					if(G.loc == G.relic)
						G.angst = 0
					else
						G.angst = max(G.angst-max(1, G.psyche), 0)
				else
					G.angst = 0
				G.lastangst = world.time
			else
				G.damaged_when_slumber = FALSE

/atom/movable/screen/ghost/outrage
	name = "Outrage"
	icon_state = "outrage"
	pathos_req = 4
	psyche_min = 4
	usable = TRUE

/atom/movable/screen/ghost/outrage/Click()
	if(..())
		for(var/obj/item/I in get_area(G))
			if(I)
				var/atom/throw_target = get_edge_target_turf(I, pick(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST))
				I.throw_at(throw_target, rand(2, 4), 5, G)
		for(var/mob/living/L in get_area(G))
			if(L)
				var/atom/throw_target = get_edge_target_turf(L, pick(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST))
				L.throw_at(throw_target, 3, 4, G)
				if(G.passion == "revenge")
					if(L == G.lastattacker)
						G.restore_pathos()
		for(var/obj/machinery/light/H in get_area(G))
			if(H)
				H.flicker()

/atom/movable/screen/ghost/lifeweb
	name = "Lifeweb"
	icon_state = "lifeweb"
	pathos_req = 2
	psyche_min = 2
	usable = TRUE

/atom/movable/screen/ghost/lifeweb/Click()
	if(..())
		G.lifeweb()

/mob/dead/observer/proc/lifeweb() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	if(isobserver(usr)) //Make sure they're an observer!
		var/list/dest = list() //List of possible destinations (mobs)
		var/target = null	   //Chosen target.

		dest += getpois(mobs_only = TRUE, skip_mindless = TRUE) //Fill list, prompt user with list
		target = tgui_input_list(src, "Please, select a soul!", "Jump to Soul", dest)

		if (!target)//Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] //Destination mob
			var/mob/A = src			 //Source mob
			var/turf/T = get_turf(M) //Turf of the destination mob

			if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
				A.forceMove(T)
				A.update_parallax_contents()
			else
				to_chat(A, "<span class='danger'>This soul is not located in the material world.</span>")

/atom/movable/screen/ghost/fascinate
	name = "Fascinate"
	icon_state = "fascinate"
	pathos_req = 3
	psyche_min = 3
	usable = TRUE

/atom/movable/screen/ghost/fascinate/Click()
	if(..())
		var/msg = input("Order:", text("Enter the text you wish to force everyone within view to obey:")) as text|null
		msg = trim(copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN))
		if (!msg)
			return
		voice_of_ghost_god(msg, G, base_multiplier = 1, message_admins = TRUE)

/atom/movable/screen/ghost/inhabit
	name = "Inhabit"
	icon_state = "inhabit"
	usable = TRUE

/atom/movable/screen/ghost/inhabit/Click()
	if(!G)
		G = usr
	if(!istype(G.loc, /turf))
		G.forceMove(get_turf(G))
	else
		if(..())
			var/list/inhabits = list()
			for(var/obj/item/I in range(1, G))
				if(I)
					inhabits += I
			for(var/obj/vampire_car/V in range(1, G))
				if(V)
					inhabits += V
			if(!length(inhabits) && G.relic)
				inhabits += G.relic
			var/result = tgui_input_list(usr, "Choose an object to inhabit", "Inhabit", sortList(inhabits))
			if(result)
				if(G.relic == result)
					G.forceMove(result)
				else
					if(G.psyche < 3)
						to_chat(G, "<span class='warning'>Connection with your Psyche is too low. Being near your fetters and anchors would raise it.</span>")
						return
					if(G.pathos < 3)
						to_chat(G, "<span class='warning'>You don't have enough Pathos. Try slumbering for a minute.</span>")
						return
					G.pathos = max(0, G.pathos-3)
					G.forceMove(result)

/atom/movable/screen/ghost/pandemonium
	name = "Pandemonium"
	icon_state = "pandemonium"
	pathos_req = 5
	psyche_min = 5
	usable = TRUE

/obj/ghostwall
	icon = 'icons/hud/wraith_passion.dmi'
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	layer = ABOVE_MOB_LAYER

/obj/fallingfloor
	density = FALSE
	anchored = TRUE
	opacity = FALSE

/atom/movable/screen/ghost/pandemonium/proc/shoot_projectile(turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new /obj/projectile/colossus(startloc)
	P.preparePixelProjectile(marker, startloc)
	P.firer = src
	P.fire(set_angle)

/atom/movable/screen/ghost/pandemonium/Click()
	if(..())
		for(var/turf/open/T in range(7, G))
			if(T)
				if(get_dist(G, T) == 7)
					var/obj/ghostwall/gwall = new (T)
					spawn(30 SECONDS)
						qdel(gwall)
				else
					if(prob(50))
						var/turftype = T.type
						var/umbral = T.umbra
						var/obj/fallingfloor/flor = new (T)
						flor.icon = T.icon
						flor.icon_state = T.icon_state
						flor.layer = T.layer
						var/matrix/M1 = matrix()
						M1.Scale(1.5, 1.5)
						var/matrix/M2 = matrix()
						M2.Scale(0.1, 0.1)
						M2.Turn(pick(-180, 180))
						animate(flor, transform = M1, time = 2 SECONDS, loop = 1)
						spawn(2 SECONDS)
							var/turf/open/chasm/C = new (T)
							animate(flor, transform = M2, alpha = 128, time = 1 SECONDS, loop = 1)
							spawn(1 SECONDS)
								qdel(flor)
								spawn(27 SECONDS)
									var/turf/open/T2 = new turftype (C)
									T2.umbra = umbral
		var/turf/start_turf = get_step(get_turf(G), pick(GLOB.alldirs))
		var/counter = 8
		var/negative = pick(TRUE, FALSE)
		for(var/i in 1 to 80)
			if(negative)
				counter--
			else
				counter++
			if(counter > 16)
				counter = 1
			if(counter < 1)
				counter = 16
			shoot_projectile(start_turf, counter * 22.5)
			sleep(1)

//		new /mob/living/simple_animal/hostile/abyss_tentacle (get_turf(G))
//		for(var/turf/open/O in view(8, G))
//			if(O)
//				if(prob(25))
//					new /mob/living/simple_animal/hostile/abyss_tentacle (O)

/atom/movable/screen/ghost/puppetry
	name = "Puppetry"
	icon_state = "puppetry"
	pathos_req = 5
	psyche_min = 5
	usable = TRUE
	var/datum/puppetry/P

/datum/action/reghost
	name = "Re-Enter Ghost"
	button_icon_state = "ghost"
	var/datum/puppetry/puppetr

/datum/action/reghost/Trigger()
	if(owner.key)
		owner.stop_sound_channel(CHANNEL_HEARTBEAT) //Stop heartbeat sounds because You Are A Ghost Now
		var/mob/dead/observer/ghost = new(owner)	// Transfer safety to observer spawning proc.
		SStgui.on_transfer(src, ghost) // Transfer NanoUIs.
		var/datum/preferences/P = GLOB.preferences_datums[ckey(owner.key)]
		if(P)
			ghost.appearance = P.ghost_preview()
			unset_busy_human_dummy(DUMMY_HUMAN_SLOT_GHOST)
			ghost.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
			ghost.invisibility = INVISIBILITY_OBSERVER
			ghost.layer = GHOST_LAYER
			var/mutable_appearance/ghost_overlay = mutable_appearance('icons/effects/64x64.dmi', "curse", ghost.layer-1)
			ghost_overlay.pixel_x = -16
			ghost_overlay.pixel_y = -16
			ghost_overlay.alpha = 196
			ghost.overlays += ghost_overlay
		//	ghost.icon = src.icon // [ChillRaccoon] - We should transfer mob visuals to the ghost
		//	ghost.overlays = src.overlays // [ChillRaccoon] - Overlays too, else we will not see wounds, hair, skin, and etc.
			ghost.color = GLOB.CMNoir	// [BadTeammate] - BOOO SCARY GHOSTS AURA
			ghost.alpha = 180
		ghost.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/ghost_varspeed, multiplicative_slowdown = ghost.movement_delay)
		// -------
		ghost.key = owner.key
//		ghost.client.init_verbs()
//		ghost.client = .client
		ghost.mind = puppetr.mind
		ghost.relic = puppetr.relic
		ghost.myplace = puppetr.myplace
		ghost.fetter = puppetr.fetter
		if(isliving(puppetr.backseat.loc))
			var/mob/living/L = puppetr.backseat.loc
			L.key = puppetr.backseat.key
			qdel(puppetr.backseat)
			qdel(puppetr)
			if(isnpc(L))
				L.add_movespeed_modifier(/datum/movespeed_modifier/npc)
			src.Remove(owner)

/atom/movable/screen/ghost/puppetry/Click()
	if(!G)
		G = usr
	var/mob/living/puppet
	for(var/mob/living/L in get_turf(G))
		if(L)
			if(isnpc(L))
				puppet = L
			else if(!ishuman(L))
				puppet = L
	if(puppet)
		if(..())
			if(!P)
				P = new ()
				P.backseat = new (puppet)
				P.fetter = G.fetter
				P.relic = G.relic
				P.myplace = G.myplace
				P.mind = G.mind
				if(puppet.key)
					P.backseat.key = puppet.key
				puppet.key = G.key
				var/datum/action/reghost/R = new
				R.puppetr = P
				R.Grant(puppet)
				puppet.remove_movespeed_modifier(/datum/movespeed_modifier/npc)
	else
		to_chat(G, "<span class='warning'>You need to be on a same turf as target.</span>")

/datum/puppetry
	var/mob/living/split_personality/backseat
	var/mob/living/fetter
	var/obj/item/relic
	var/area/vtm/myplace
	var/datum/mind/mind

/atom/movable/screen/ghost/embody
	name = "Embody"
	icon_state = "embody"
	pathos_req = 4
	psyche_min = 4
	usable = TRUE

/atom/movable/screen/ghost/embody/Click()
	if(!G)
		G = usr
	if(G.invisibility == 0)
		G.invisibility = INVISIBILITY_OBSERVER
		G.alpha = 180
	else
		if(..())
			G.invisibility = 0
			G.alpha = 255

/atom/movable/screen/ghost/pathos
	name = "Pathos"
	icon = 'icons/hud/wraith_hud.dmi'
	icon_state = "pathos10"

/atom/movable/screen/ghost/psyche
	name = "Psyche"
	icon = 'icons/hud/wraith_hud.dmi'
	icon_state = "psyche0"

/atom/movable/screen/ghost/corpus
	name = "Corpus"
	icon = 'icons/hud/wraith_corpus.dmi'
	icon_state = "corpus10"

/atom/movable/screen/ghost/angst
	name = "Angst"
	icon = 'icons/hud/wraith_angst.dmi'
	icon_state = "angst0"

/atom/movable/screen/ghost/passion
	name = "Passion"
	icon = 'icons/hud/wraith_passion.dmi'
//	icon_state = "corpus10"

// [ChillRaccoon] - LFWB like ghost GUI


/atom/movable/screen/fullscreen/ghost/lfwbLike
	icon = 'icons/hud/fullscreen.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer1/New()
	..()
	var/matrix/M = matrix()
	M.Scale(1.5, 1.5)
	src.transform = M

/atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer1 // [ChillRaccoon] - this layer should overlap screenLayer2
	name = ""
	icon_state = "ghost1"
	icon_state = "curse1"
	layer = UI_DAMAGE_LAYER
	alpha = 160
	color = list(0.3,0.3,0.3,0,\
				0.3,0.3,0.3,0,\
				0.3,0.3,0.3,0,\
				0.0,0.0,0.0,1,)

/atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer2
	name = ""
	icon_state = "ghost2"
	alpha = 128

/datum/hud/ghost/New(mob/owner)
	..()
	static_noise = new /atom/movable/screen()
	static_noise.mouse_opacity = 0
	static_noise.icon = 'icons/hud/screen_gen.dmi'
	static_noise.screen_loc = "WEST,SOUTH to EAST,NORTH"
	static_noise.icon_state = "static_base"
	static_noise.alpha = 6
	static_inventory += static_noise

	var/atom/movable/screen/using
//	using = new /atom/movable/screen/ghost/jumptomob()
//	using.screen_loc = ui_ghost_jumptomob
//	using.hud = src
//	static_inventory += using

//	using = new /atom/movable/screen/ghost/orbit()
//	using.screen_loc = ui_ghost_orbit
//	using.hud = src
//	static_inventory += using

	using = new /atom/movable/screen/ghost/reenter_corpse()
	using.screen_loc = ui_ghost_reenter_corpse
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/teleport()
	using.screen_loc = ui_ghost_teleport
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/respawn()
	using.screen_loc = ui_ghost_respawn
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/keening()
	using.screen_loc = ui_ghost_keening
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/slumber()
	using.screen_loc = ui_ghost_slumber
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/outrage()
	using.screen_loc = ui_ghost_outrage
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/lifeweb()
	using.screen_loc = ui_ghost_lifeweb
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/fascinate()
	using.screen_loc = ui_ghost_fascinate
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/inhabit()
	using.screen_loc = ui_ghost_inhabit
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/pandemonium()
	using.screen_loc = ui_ghost_pandemonium
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/puppetry()
	using.screen_loc = ui_ghost_puppetry
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/embody()
	using.screen_loc = ui_ghost_embody
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/fullscreen_hud/ghost()
	using.screen_loc = ui_full_inventory
	using.hud = src
	static_inventory += using

	zone_icon = new /atom/movable/screen/vtm_zone()
	zone_icon.screen_loc = ui_vtm_zone
	zone_icon.hud = src
	static_inventory += zone_icon

	secret_zone_icon = new /atom/movable/screen()
	secret_zone_icon.screen_loc = ui_vtm_zone
	secret_zone_icon.hud = src
	static_inventory += secret_zone_icon

	pathos_icon = new /atom/movable/screen/ghost/pathos()
	pathos_icon.screen_loc = ui_full_inventory
	pathos_icon.hud = src
	static_inventory += pathos_icon

	psyche_icon = new /atom/movable/screen/ghost/psyche()
	psyche_icon.screen_loc = ui_full_inventory
	psyche_icon.hud = src
	static_inventory += psyche_icon

	corpus_icon = new /atom/movable/screen/ghost/corpus()
	corpus_icon.screen_loc = ui_ghost_corpus
	corpus_icon.hud = src
	static_inventory += corpus_icon

	angst_icon = new /atom/movable/screen/ghost/angst()
	angst_icon.screen_loc = ui_ghost_angst
	angst_icon.hud = src
	static_inventory += angst_icon

	passion_icon = new /atom/movable/screen/ghost/passion()
	passion_icon.screen_loc = ui_ghost_passion
	passion_icon.hud = src
	static_inventory += passion_icon

	fetter_icon = new /atom/movable/screen/ghost()
	fetter_icon.screen_loc = ui_ghost_fetter
	fetter_icon.hud = src
	static_inventory += fetter_icon

	relic_icon = new /atom/movable/screen/ghost()
	relic_icon.screen_loc = ui_ghost_relic
	relic_icon.hud = src
	static_inventory += relic_icon

//	using = new /atom/movable/screen/ghost/pai()
//	using.screen_loc = ui_ghost_pai
//	using.hud = src
//	static_inventory += using

//	using = new /atom/movable/screen/language_menu
//	using.icon = ui_style
//	using.hud = src
//	static_inventory += using


	// [ChillRaccoon] - LFWB like GUI implementation


	using = new /atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer1
	using.hud = src
	using.screen_loc = "CENTER-7,CENTER-7"
	static_inventory += using

	using = new /atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer2
	using.hud = src
	using.screen_loc = "CENTER-7,CENTER-7"
	static_inventory += using

/datum/hud/ghost/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	/* // [ChillRaccoon] - do a little trolling
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else*/
	//if(!check_rights_for(screenmob.client, R_ADMIN)) // [ChillRaccoon] - administration shouldn't see overlays
	// to_chat(screenmob.client, "Check rights (overlays) - [check_rights_for(screenmob.client, R_ADMIN)]")

	screenmob.client.screen += static_inventory

//We should only see observed mob alerts.
/datum/hud/ghost/reorganize_alerts(mob/viewmob)
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		return
	. = ..()

/atom/movable/screen/ghost/appearance/auspex
	name = "Appearance"
	icon_state = "auspex"
	pathos_req = 0
	psyche_min = 0
	usable = TRUE

/atom/movable/screen/ghost/appearance/auspex/Click()
	if(..())
		G.showing()

/atom/movable/screen/ghost/auspex/reenter_corpse
	name = "Reenter corpse"
	icon_state = "reenter_corpse"
	usable = TRUE

/atom/movable/screen/ghost/auspex/reenter_corpse/Click()
	..()
	G.reenter_corpse()

/datum/hud/auspex_avatar/New(mob/owner)
	..()
	static_noise = new /atom/movable/screen()
	static_noise.mouse_opacity = 0
	static_noise.icon = 'icons/hud/screen_gen.dmi'
	static_noise.screen_loc = "WEST,SOUTH to EAST,NORTH"
	static_noise.icon_state = "static_base"
	static_noise.alpha = 6
	static_inventory += static_noise

	var/atom/movable/screen/using

	using = new /atom/movable/screen/ghost/auspex/reenter_corpse
	using.screen_loc = ui_ghost_outrage
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/appearance/auspex
	using.screen_loc = ui_ghost_lifeweb
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer1
	using.hud = src
	using.screen_loc = "CENTER-7,CENTER-7"
	static_inventory += using

	using = new /atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer2
	using.hud = src
	using.screen_loc = "CENTER-7,CENTER-7"
	static_inventory += using

	using = new /atom/movable/screen/fullscreen_hud/ghost()
	using.screen_loc = ui_full_inventory
	using.hud = src
	static_inventory += using

	zone_icon = new /atom/movable/screen/vtm_zone()
	zone_icon.screen_loc = ui_vtm_zone
	zone_icon.hud = src
	static_inventory += zone_icon

	secret_zone_icon = new /atom/movable/screen()
	secret_zone_icon.screen_loc = ui_vtm_zone
	secret_zone_icon.hud = src
	static_inventory += secret_zone_icon

/datum/hud/auspex_avatar/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/avatar/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	/* // [ChillRaccoon] - do a little trolling
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else*/
	//if(!check_rights_for(screenmob.client, R_ADMIN)) // [ChillRaccoon] - administration shouldn't see overlays
	// to_chat(screenmob.client, "Check rights (overlays) - [check_rights_for(screenmob.client, R_ADMIN)]")

	screenmob.client.screen += static_inventory

/datum/hud/auspex_avatar/reorganize_alerts(mob/viewmob)
	var/mob/dead/observer/avatar/O = mymob
	if (istype(O) && O.observetarget)
		return
	. = ..()
