GLOBAL_LIST_EMPTY(ghost_images_default) //this is a list of the default (non-accessorized, non-dir) images of the ghosts themselves
GLOBAL_LIST_EMPTY(ghost_images_simple) //this is a list of all ghost images as the simple white ghost

GLOBAL_VAR_INIT(observer_default_invisibility, INVISIBILITY_OBSERVER)

GLOBAL_LIST_INIT(CMNoir, list(0.3,0.3,0.3,0,\
							0.3,0.3,0.3,0,\
							0.3,0.3,0.3,0,\
							0.0,0.0,0.0,1,))// [ChillRaccoon] - more about "color matrix" you can read in BYOND documentation

/mob/dead/observer
	name = "ghost"
	//desc = "It's a g-g-g-g-ghooooost" //jinkies! //[ChillRaccon] - maggot
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	layer = GHOST_LAYER
	stat = DEAD
	alpha = 128
	density = FALSE
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 100
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	invisibility = INVISIBILITY_OBSERVER
	hud_type = /datum/hud/ghost
	movement_type = GROUND | PHASING	// [BadTeammate] - Fuck you luci //[Lucifernix] - phasing is what lets ghosts walk through walls, so I readded it
//	move_resist = MOVE_FORCE_OVERPOWERING
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 2
	light_on = FALSE
	sight = 0
	hud_possible = list(GHOST_HUD)
	var/can_reenter_corpse
	var/datum/hud/living/carbon/hud = null // hud
	var/bootime = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghost - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/movement_delay = 2 // [ChillRaccoon] - movement delay
	var/atom/movable/following = null
	var/fun_verbs = 0
	var/image/ghostimage_default = null //this mobs ghost image without accessories and dirs
	var/image/ghostimage_simple = null //this mob with the simple white ghost sprite
	var/ghostvision = 1 //is the ghost able to see things humans can't?
	var/mob/observetarget = null	//The target mob that the ghost is observing. Used as a reference in logout()
	var/ghost_hud_enabled = 1 //did this ghost disable the on-screen HUD?
	var/data_huds_on = 0 //Are data HUDs currently enabled?
	var/health_scan = FALSE //Are health scans currently enabled?
	var/chem_scan = FALSE //Are chem scans currently enabled?
	var/gas_scan = FALSE //Are gas scans currently enabled?
	var/list/datahuds = list(DATA_HUD_SECURITY_ADVANCED, DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_ADVANCED) //list of data HUDs shown to ghosts.
	var/ghost_orbit = GHOST_ORBIT_CIRCLE

	//These variables store hair data if the ghost originates from a species with head and/or facial hair.
	var/hairstyle
	var/hair_color
	var/mutable_appearance/hair_overlay
	var/facial_hairstyle
	var/facial_hair_color
	var/mutable_appearance/facial_hair_overlay

	var/updatedir = 1						//Do we have to update our dir as the ghost moves around?
	var/lastsetting = null	//Stores the last setting that ghost_others was set to, for a little more efficiency when we update ghost images. Null means no update is necessary

	//We store copies of the ghost display preferences locally so they can be referred to even if no client is connected.
	//If there's a bug with changing your ghost settings, it's probably related to this.
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	// Used for displaying in ghost chat, without changing the actual name
	// of the mob
	var/deadchat_name
	var/datum/orbit_menu/orbit_menu
	var/datum/spawners_menu/spawners_menu
	var/aghosted = FALSE

	var/corpus = 10
	var/angst = 0
	var/lastangst = 0
	var/psyche = 5
	var/pathos = 5
	var/area/vtm/myplace
	var/obj/item/relic
	var/mob/living/fetter

	var/mob/camera/shadow
	var/image/current_image

	var/acting = FALSE
	var/lastattack = 0

	var/lastcorpusdamage = 0

	var/lastslumber = - 1 MINUTES

	var/lastpathosrestore = - 30 SECONDS

	var/passion = "curiousity"	//Love, Anger, Revenge

	var/mob/living/lastattacker

/obj/item/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_NECROMANCY_KNOWLEDGE))
		for(var/mob/dead/observer/O in GLOB.player_list)
			if(O)
				if(O.relic == src)
					var/soul_loc = "But they're far away from here..."
					if(get_area(O) == get_area(src))
						soul_loc = "And they seem to be somewhere close..."
					to_chat(user, "<span class='hypnophrase'>This item is a relic to a ghost. [soul_loc]</span>")

/obj/item/attack_self(mob/user)
	for(var/mob/dead/observer/O in GLOB.player_list)
		if(O)
			if(O.relic == src)
				to_chat(O, "<span class='hypnophrase'>A NEW HAND TOUCHES THE RELIC</span>")
				to_chat(user, "<span class='warning'>You feel cold air surrounding you...</span>")
				O.forceMove(get_turf(src))
	. = ..()

/mob/dead/observer/proc/restore_pathos()
	if(lastpathosrestore < world.time)
		lastpathosrestore = world.time + 30 SECONDS
		pathos = min(pathos+1, 10)

/mob/spectre
	name = "???"
	desc = "It's coming closer..."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "curseblob"
	density = FALSE
	anchored = TRUE
	movement_type = GROUND | PHASING | FLYING
	invisibility = INVISIBILITY_OBSERVER
	move_resist = MOVE_FORCE_OVERPOWERING
	layer = GHOST_LAYER
	stat = DEAD
	alpha = 180

	var/mob/dead/observer/target

/mob/spectre/Initialize()
	. = ..()
	color = GLOB.CMNoir
	GLOB.spectre_list += src

/mob/spectre/Destroy()
	GLOB.spectre_list -= src
	. = ..()

/mob/spectre/proc/handle_haunting()
	if(target)
		if(get_dist(src, get_turf(target)) > 7)
			target = null
		if(target.corpus == 0)
			target = null

	if(target)
		if(x > target.x)
			x = x-1
		if(x < target.x)
			x = x+1
		if(y > target.y)
			y = y-1
		if(y < target.y)
			y = y+1
		if(get_dist(src, get_turf(target)) <= 1)
			target.damage_corpus()
	else
		for(var/mob/dead/observer/O in viewers(7, src))
			if(O)
				if(O.corpus > 0)
					target = O
		if(!target)
			if(prob(10))
				var/nextstep = get_step(src, pick(NORTH, SOUTH, EAST, WEST))
				forceMove(nextstep)

/mob/dead/observer/proc/damage_corpus()
	if (check_rights_for(client, R_ADMIN))
		return
	if(corpus == 0)
		return
	transform = null
	damaged_when_slumber = TRUE
	slumbercooldown = world.time + 2 MINUTES
	lastslumber = world.time
	if(lastcorpusdamage < world.time)
		lastcorpusdamage = world.time+15 SECONDS
		if(invisibility == 0)
			lastcorpusdamage = world.time+2 SECONDS
		corpus = max(0, corpus-1)
		new /obj/effect/decal/remains/plasma (get_turf(src))
		to_chat(src, "<span class='danger'>You feel pain, like you did when you where alive!</span>")
		playsound(get_turf(src), 'sound/effects/ghost.ogg', 100, TRUE)
		for(var/mob/M in orange(7, src))
			if(M)
				to_chat(M, "<span class='phobia'>Something screeches through the fabric of existence...</span>")
		if(hud_used)
			hud_used.corpus_icon.icon_state = "corpus[corpus]"

	var/turf/tur = get_turf(src)

	if(corpus == 0)
		relic = null
//		qdel(relic)
		var/area/are
		for(var/area/A in world)
			if(A.name == "Backrooms")
				are = A

		if(are)
			var/list/L = list()
			for(var/turf/T in get_area_turfs(are.type))
				L+=T

			usr.forceMove(pick(L))
			update_parallax_contents()
		else
			if(client)
				client.screen.Cut()
				client.screen += client.void

			var/mob/dead/new_player/M = new /mob/dead/new_player()
			src << sound(null)
			M.key = key
		new /mob/spectre (tur)

/mob/dead/observer/Initialize(mapload)
	shadow = new(get_turf(src))
	current_image = image('code/modules/wod13/wraith_shadow.dmi', shadow, "shadow", ABOVE_LIGHTING_LAYER)
	current_image.override = TRUE
	set_invisibility(GLOB.observer_default_invisibility)

	add_verb(src, list(
		/mob/dead/observer/proc/dead_tele,
		/mob/dead/observer/proc/open_spawners_menu,
		/mob/dead/observer/proc/tray_view))

//	if(icon_state in GLOB.ghost_forms_with_directions_list)
//		ghostimage_default = image(src.icon,src,src.icon_state + "_nodir")
//	else
//		ghostimage_default = image(src.icon,src,src.icon_state)
//	ghostimage_default.override = TRUE
//	GLOB.ghost_images_default |= ghostimage_default

//	ghostimage_simple = image(src.icon,src,"ghost_nodir")
//	ghostimage_simple.override = TRUE
//	GLOB.ghost_images_simple |= ghostimage_simple

	updateallghostimages()

	var/turf/T
	var/mob/body = loc
	if(ismob(body))
		T = get_turf(body)				//Where is the body located?

		gender = body.gender
		if(body.mind && body.mind.name)
			if(body.mind.ghostname)
				name = body.mind.ghostname
			else
				name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				name = random_unique_name(gender)

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.
		set_suicide(body.suiciding) // Transfer whether they committed suicide.

	update_icon()

	if(!T)
		var/list/turfs = get_area_turfs(/area/shuttle/arrival)
		if(turfs.len)
			T = pick(turfs)
		else
			T = SSmapping.get_station_center()

	forceMove(T)

	if(!name)							//To prevent nameless ghosts
		name = random_unique_name(gender)
	real_name = name

	remove_verb(src, /mob/dead/observer/verb/possess)

	add_to_dead_mob_list()

	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)

	. = ..()

	var/datum/atom_hud/ghost_hud = GLOB.huds[DATA_HUD_GHOST]
	ghost_hud.add_to_hud(src)
	update_ghost_hud()

	grant_all_languages()
	show_data_huds()
	data_huds_on = 1

	grant_all_languages()
	show_data_huds()
	data_huds_on = 1


/mob/dead/observer/get_photo_description(obj/item/camera/camera)
	if(!invisibility || camera.see_ghosts)
		return "You can also see a g-g-g-g-ghooooost!" // [ChillRaccoon] - maggot

/mob/dead/observer/narsie_act()
	var/old_color = color
	color = "#960000"
	animate(src, color = old_color, time = 10, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 10)

/mob/dead/observer/Destroy()
	if(data_huds_on)
		remove_data_huds()

	// Update our old body's medhud since we're abandoning it
	if(mind?.current)
		mind.current.med_hud_set_status()

	GLOB.ghost_images_default -= ghostimage_default
	QDEL_NULL(ghostimage_default)

	GLOB.ghost_images_simple -= ghostimage_simple
	QDEL_NULL(ghostimage_simple)

	updateallghostimages()

	var/datum/atom_hud/ghost_hud = GLOB.huds[DATA_HUD_GHOST]
	ghost_hud.remove_from_hud(src)

	QDEL_NULL(orbit_menu)
	QDEL_NULL(spawners_menu)
	return ..()

/*
 * This proc will update the icon of the ghost itself, with hair overlays, as well as the ghost image.
 * Please call update_icon(icon_state) from now on when you want to update the icon_state of the ghost,
 * or you might end up with hair on a sprite that's not supposed to get it.
 * Hair will always update its dir, so if your sprite has no dirs the haircut will go all over the place.
 * |- Ricotez
 */
/mob/dead/observer/update_icon(new_form)
	. = ..()

	if(client) //We update our preferences in case they changed right before update_icon was called.
		ghost_accs = client.prefs.ghost_accs
		ghost_others = client.prefs.ghost_others

	if(hair_overlay)
		cut_overlay(hair_overlay)
		hair_overlay = null

	if(facial_hair_overlay)
		cut_overlay(facial_hair_overlay)
		facial_hair_overlay = null


	if(new_form)
		icon_state = new_form
//		if(icon_state in GLOB.ghost_forms_with_directions_list)
//			ghostimage_default.icon_state = new_form + "_nodir" //if this icon has dirs, the default ghostimage must use its nodir version or clients with the preference set to default sprites only will see the dirs
//		else
//			ghostimage_default.icon_state = new_form

	if(ghost_accs >= GHOST_ACCS_DIR && (icon_state in GLOB.ghost_forms_with_directions_list)) //if this icon has dirs AND the client wants to show them, we make sure we update the dir on movement
		updatedir = 1
	else
		updatedir = 0	//stop updating the dir in case we want to show accessories with dirs on a ghost sprite without dirs
		setDir(2 		)//reset the dir to its default so the sprites all properly align up

/*
 * Increase the brightness of a color by calculating the average distance between the R, G and B values,
 * and maximum brightness, then adding 30% of that average to R, G and B.
 *
 * I'll make this proc global and move it to its own file in a future update. |- Ricotez
 */
/mob/proc/brighten_color(input_color)
	var/r_val
	var/b_val
	var/g_val
	var/color_format = length(input_color)
	if(color_format != length_char(input_color))
		return 0
	if(color_format == 3)
		r_val = hex2num(copytext(input_color, 1, 2)) * 16
		g_val = hex2num(copytext(input_color, 2, 3)) * 16
		b_val = hex2num(copytext(input_color, 3, 4)) * 16
	else if(color_format == 6)
		r_val = hex2num(copytext(input_color, 1, 3))
		g_val = hex2num(copytext(input_color, 3, 5))
		b_val = hex2num(copytext(input_color, 5, 7))
	else
		return 0 //If the color format is not 3 or 6, you're using an unexpected way to represent a color.

	r_val += (255 - r_val) * 0.4
	if(r_val > 255)
		r_val = 255
	g_val += (255 - g_val) * 0.4
	if(g_val > 255)
		g_val = 255
	b_val += (255 - b_val) * 0.4
	if(b_val > 255)
		b_val = 255

	return copytext(rgb(r_val, g_val, b_val), 2)

/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/proc/ghostize(can_reenter_corpse = TRUE, aghosted = FALSE, check_key = FALSE)
	if(check_key)
		if(stat != DEAD && client)
			return
	if(key)
	/*
		if(client)
			client.show_popup_menus = TRUE // [ChillRaccoon] - i a little bit rewrote that system, so we do not need it here anymore, else it can broke the things
	*/
		//if(key[1] != "@") // Skip aghosts.
		stop_sound_channel(CHANNEL_HEARTBEAT) //Stop heartbeat sounds because You Are A Ghost Now
		var/mob/dead/observer/ghost = new(src)	// Transfer safety to observer spawning proc.
		var/list/relics = list()
		for(var/obj/item/I in range(2, src))
			if(I)
				relics += I
		for(var/obj/item/I in src.contents)
			if(I)
				relics += I
		if(length(relics))
			ghost.relic = pick(relics)
		var/list/enemieslist = list()
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			if(H.Myself?.Lover?.owner)
				ghost.fetter = H.Myself?.Lover?.owner
			else if(H.Myself?.Friend?.owner)
				ghost.fetter = H.Myself?.Friend?.owner
			if(H.Myself?.Enemy?.owner)
				enemieslist += H.Myself?.Enemy?.owner
			for(var/mob/living/L in GLOB.player_list)
				if(L)
					if(L.true_real_name == H.lastattacker)
						enemieslist += L
//						ghost.lastattacker = L
		SStgui.on_transfer(src, ghost) // Transfer NanoUIs.
		ghost.can_reenter_corpse = can_reenter_corpse
		// [ChillRaccoon] - setting mob icons
		var/datum/preferences/P = GLOB.preferences_datums[ckey(key)]
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

	//	add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/ghost_varspeed, multiplicative_slowdown = ghost.movement_delay)
		// -------
		ghost.key = key
		ghost.client.init_verbs()
		ghost.client = src.client
		ghost.aghosted = aghosted
		if(aghosted)
			ghost.movement_delay = 0
			// to_chat(ghost.client, "Check rights - [check_rights_for(ghost.client, R_ADMIN)]")
			ghost.sight = SEE_TURFS | SEE_MOBS | SEE_OBJS
			ghost.movement_type = FLYING | PHASING | GROUND // [ChillRaccoon] - makes us available to go through dens objects [Lucifernix] - It was += that made aghosts unable to phase here.
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/ghost_varspeed, multiplicative_slowdown = ghost.movement_delay)

		if(!can_reenter_corpse)	// Disassociates observer mind from the body mind
			ghost.mind = null
		if(istype(get_area(ghost), /area/vtm))
			ghost.myplace = get_area(ghost)
		if(length(relics) && !aghosted)
			var/result = tgui_input_list(ghost, "Choose a relic", "Relic", sortList(relics))
			if(result)
				ghost.relic = result
		var/list/passions = list("anger", "curiousity")
		if(ghost.fetter)
			passions += "love"
//		if(isliving(src))
//			var/mob/living/liv = src
		if(length(enemieslist))
			passions += "revenge"
		if(!aghosted)
			var/strast = tgui_input_list(ghost, "Choose a passion", "Passion", sortList(passions))
			if(strast)
				ghost.passion = strast
				if(strast == "revenge")
					ghost.lastattacker = pick(enemieslist)
					var/enemi = tgui_input_list(ghost, "Who's your main rival?", "Revenge", sortList(enemieslist))
					if(enemi)
						ghost.lastattacker = enemi
		return ghost

/mob/living/ghostize(can_reenter_corpse = TRUE, aghosted = FALSE)
	. = ..()
	if(. && can_reenter_corpse)
		var/mob/dead/observer/ghost = .
		ghost.mind.current?.med_hud_set_status()

/mob/dead/observer/proc/update_psyche()
	var/fetter_around = 0
	if(fetter)
		if(hud_used?.fetter_icon)
			hud_used.fetter_icon.cut_overlays()
			var/mutable_appearance/M = fetter.appearance
			hud_used.fetter_icon.add_overlay(M)
			hud_used.fetter_icon.maptext_width = 96
			hud_used.fetter_icon.maptext_height = 24
			hud_used.fetter_icon.maptext_x = -16
			hud_used.fetter_icon.maptext_y = -8
			hud_used.fetter_icon.maptext = MAPTEXT("[dir2text(get_dir(get_turf(src), get_turf(fetter)))] [get_dist(get_turf(src), get_turf(fetter))]")
		if(get_area(fetter) == get_area(src))
			fetter_around = 1
			if(get_dist(get_turf(src), get_turf(fetter)) <= 4)
				if(passion == "love")
					restore_pathos()
	else
		if(hud_used?.fetter_icon)
			hud_used.fetter_icon.cut_overlays()
	if(passion == "revenge")
		if(hud_used?.passion_icon)
			hud_used.passion_icon.cut_overlays()
			if(lastattacker)
				var/mutable_appearance/M = lastattacker.appearance
				hud_used.passion_icon.add_overlay(M)
				hud_used.passion_icon.maptext_width = 96
				hud_used.passion_icon.maptext_height = 24
//			hud_used.fetter_icon.maptext_x = -16
				hud_used.passion_icon.maptext_y = 24
				hud_used.passion_icon.maptext = MAPTEXT("[dir2text(get_dir(get_turf(src), get_turf(fetter)))] [get_dist(get_turf(src), get_turf(fetter))]")
			else
				hud_used.passion_icon.maptext = MAPTEXT("")
	var/relic_around = 0
	var/in_relic = 0
	if(relic)
		if(loc == relic)
			in_relic = 1
		if(hud_used?.relic_icon)
			hud_used.relic_icon.cut_overlays()
			var/icon/I = icon(initial(relic.icon), initial(relic.icon_state))
			hud_used.relic_icon.add_overlay(I)
			hud_used.relic_icon.maptext_width = 96
			hud_used.relic_icon.maptext_height = 24
			hud_used.fetter_icon.maptext_x = 16
			hud_used.relic_icon.maptext_y = -8
			hud_used.relic_icon.maptext = MAPTEXT("[dir2text(get_dir(get_turf(src), get_turf(relic)))] [get_dist(get_turf(src), get_turf(relic))]")
		if(get_area(relic) == get_area(src))
			relic_around = 1
	else
		if(hud_used?.relic_icon)
			hud_used.relic_icon.cut_overlays()
	var/low_wall = 0
	var/deaths_here = 0
	if(istype(get_area(src), /area/vtm))
		var/area/vtm/V = get_area(src)
		if(V.wall_rating == 1)
			low_wall = 1
		if(V.deathcounter > 0)
			deaths_here = 1
		if(V.deathcounter >= 5)
			deaths_here = 2
	var/my_death_here = 0
	if(get_area(src) == myplace)
		my_death_here = 1
	psyche = clamp(fetter_around+relic_around+low_wall+deaths_here+my_death_here+in_relic, 0, 5)
	if(hud_used?.psyche_icon)
		hud_used.psyche_icon.icon_state = "psyche[psyche]"
	if(hud_used?.pathos_icon)
		hud_used.pathos_icon.icon_state = "pathos[pathos]"
	if(hud_used?.passion_icon)
		hud_used.passion_icon.icon_state = "[passion]"
	switch(psyche)
		if(0)
			if(lastangst+30 SECONDS < world.time)
				lastangst = world.time
				angst = min(angst+1, 10)
				to_chat(src, "<span class='warning'>You feel your Shadow approaching...</span>")
		if(1)
			if(lastangst+60 SECONDS < world.time)
				lastangst = world.time
				angst = min(angst+1, 10)
				to_chat(src, "<span class='warning'>You feel your Shadow approaching...</span>")
		if(2)
			if(lastangst+90 SECONDS < world.time)
				lastangst = world.time
				angst = min(angst+1, 10)
				to_chat(src, "<span class='warning'>You feel your Shadow approaching...</span>")
		if(3)
			if(lastangst+120 SECONDS < world.time)
				lastangst = world.time
				angst = min(angst+1, 10)
				to_chat(src, "<span class='warning'>You feel your Shadow approaching...</span>")
		if(4)
			if(lastangst+150 SECONDS < world.time)
				lastangst = world.time
				angst = min(angst+1, 10)
				to_chat(src, "<span class='warning'>You feel your Shadow approaching...</span>")
		if(5)
			lastangst = world.time

	if(hud_used?.angst_icon)
		hud_used.angst_icon.icon_state = "angst[angst]"

	if(client)
		client.images.Remove(current_image)
		if(angst == 10 && corpus > 0)
			client.images |= current_image
			if(get_dist(get_turf(src), shadow) > 7)
				var/list/openturfs = list()
				for(var/turf/open/O in view(6, src))
					if(O)
						if(get_dist(get_turf(src), O) >= 4)
							openturfs += O
				if(length(openturfs))
					shadow.forceMove(pick(openturfs))
			if(get_dist(get_turf(src), shadow) <= 1)
				corpus = 1
				damage_corpus()
			var/shadowphrase = list("ЭТО ВСЁ ТВОЯ ВИНА", "ТЫ БЕЗДАРНОСТЬ", "ДАЖЕ БУДУЧИ МЁРТВЫМ ТЫ ОСТАЁШЬСЯ НИКЧЁМНЫМ", "ТЕБЕ ЛУЧШЕ ЗАБЫТЬСЯ НАВСЕГДА", "СЕЙЧАС ТЕБЕ СТАНЕТ ЕЩЁ ХУЖЕ")
			if(prob(10))
				to_chat(src, "<span class='phobia'>[pick(shadowphrase)]</span>")
			if(shadow.x > x)
				shadow.x = shadow.x-1
			if(shadow.x < x)
				shadow.x = shadow.x+1
			if(shadow.y > y)
				shadow.y = shadow.y-1
			if(shadow.y < y)
				shadow.y = shadow.y+1
/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

//	if(stat != DEAD)
//		death()
	if(stat == DEAD && !isobserver(src))
		ghostize(TRUE)
		return TRUE
	return FALSE

/mob/camera/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	var/response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost whilst still alive you may not play again this round! You can't change your mind so choose wisely!!)","Are you sure you want to ghost?","Ghost","Stay in body")
	if(response != "Ghost")
		return
	ghostize(FALSE)

/mob/dead/observer/Move(NewLoc, direct, glide_size_override = 32)
	update_zone_hud()
	update_psyche()
	dir = get_dir(loc, NewLoc)
	if(acting)
		return
	if(lastslumber > world.time)
		return
//	for(var/mob/living/L in NewLoc)
//		if(L)
//			if(L.a_intent == INTENT_HARM && L.lying_angle == 0 && L.dir != dir)
//				return
//			else
//				to_chat(L, "<span class='warning'>You feel cold air rushing through you.</span>")
//				return

	var/obj/transfer_point_vamp/V = locate() in NewLoc
	if(V)
		V.Bumped(src)
	if(get_dist(get_turf(src), shadow) > 7)
		var/list/openturfs = list()
		for(var/turf/open/O in view(6, src))
			if(O)
				if(get_dist(get_turf(src), O) >= 4)
					openturfs += O
		if(length(openturfs))
			shadow.forceMove(pick(openturfs))
	..()
/*
	if(updatedir)
		setDir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own
	var/oldloc = loc

	dir = get_dir(oldloc, NewLoc)

	if(glide_size_override)
		set_glide_size(glide_size_override)
	if(NewLoc)
		forceMove(NewLoc)
		update_parallax_contents()
	else
		forceMove(get_turf(src))  //Get out of closets and such as a ghost
		if((direct & NORTH) && y < world.maxy)
			y++
		else if((direct & SOUTH) && y > 1)
			y--
		if((direct & EAST) && x < world.maxx)
			x++
		else if((direct & WEST) && x > 1)
			x--

	Moved(oldloc, direct)
*/
/mob/dead/observer/proc/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"
	if(!client)
		return
	if(!mind || QDELETED(mind.current))
		to_chat(src, "<span class='warning'>You have no body.</span>")
		return
	if(!can_reenter_corpse)
		to_chat(src, "<span class='warning'>You cannot re-enter your body.</span>")
		return
	if(corpus == 0)
		return

	var/mob/living/carbon/human/original_body = mind.current

	if(mind.current.key && mind.current.key[1] != "@")	//makes sure we don't accidentally kick any clients
		to_chat(usr, "<span class='warning'>Another consciousness is in your body...It is resisting you.</span>")
		return
	client.view_size.setDefault(getScreenSize(client.prefs.widescreenpref))//Let's reset so people can't become allseeing gods
	// client.show_popup_menus = FALSE
	SStgui.on_transfer(src, mind.current) // Transfer NanoUIs.
	mind.current.remove_movespeed_modifier(/datum/movespeed_modifier/ghost_varspeed)
	mind.current.key = key
	mind.current.client.init_verbs()
	original_body.soul_state = SOUL_PRESENT
	return TRUE

/mob/dead/observer/verb/stay_dead()
	set category = "Ghost"
	set name = "Do Not Resuscitate"
	if(!client)
		return
	if(!can_reenter_corpse)
		to_chat(usr, "<span class='warning'>You're already stuck out of your body!</span>")
		return FALSE

	var/response = alert(src, "Are you sure you want to prevent (almost) all means of resuscitation? This cannot be undone. ","Are you sure you want to stay dead?","DNR","Save Me")
	if(response != "DNR")
		return

	can_reenter_corpse = FALSE
	// Update med huds
	var/mob/living/carbon/current = mind.current
	current.med_hud_set_status()
	// Disassociates observer mind from the body mind
	mind = null

	to_chat(src, "<span class='boldnotice'>You can no longer be brought back into your body.</span>")
	return TRUE

/mob/dead/observer/proc/notify_cloning(message, sound, atom/source, flashwindow = TRUE)
	if(flashwindow)
		window_flash(client)
	if(message)
		to_chat(src, "<span class='ghostalert'>[message]</span>")
		if(source)
			var/atom/movable/screen/alert/A = throw_alert("[REF(source)]_notify_cloning", /atom/movable/screen/alert/notify_cloning)
			if(A)
				if(client && client.prefs && client.prefs.UI_style)
					A.icon = ui_style2icon(client.prefs.UI_style)
				A.desc = message
				var/old_layer = source.layer
				var/old_plane = source.plane
				source.layer = FLOAT_LAYER
				source.plane = FLOAT_PLANE
				A.add_overlay(source)
				source.layer = old_layer
				source.plane = old_plane
	to_chat(src, "<span class='ghostalert'><a href=byond://?src=[REF(src)];reenter=1>(Click to re-enter)</a></span>")
	if(sound)
		SEND_SOUND(src, sound(sound))

/mob/dead/observer/proc/dead_tele()
	set category = "Ghost"
	set name = "Teleport"
	set desc= "Teleport to a location"
	if(!isobserver(usr))
		to_chat(usr, "<span class='warning'>Not when you're not dead!</span>")
		return
	if(corpus == 0)
		return
	var/list/filtered = list()
	for(var/V in GLOB.sortedAreas)
		var/area/A = V
		if(!(A.area_flags & HIDDEN_AREA))
			filtered += A
	var/area/thearea = tgui_input_list(src, "Area to jump to", "BOOYEA", filtered)

	if(!thearea)
		return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		to_chat(usr, "<span class='warning'>No area available.</span>")
		return

	usr.forceMove(pick(L))
	update_parallax_contents()

/mob/dead/observer/verb/follow()
	set category = "Ghost"
	set name = "Orbit" // "Haunt"
	set desc = "Follow and orbit a mob."
	if(!check_rights_for(client, R_ADMIN))
		to_chat(src, "<span class='warning'>Available only for admins.</span>")
		return
	if(!orbit_menu)
		orbit_menu = new(src)

	orbit_menu.ui_interact(src)

// This is the ghost's follow verb with an argument
/mob/dead/observer/proc/ManualFollow(atom/movable/target)
	if (!istype(target))
		return

	if(!check_rights_for(client, R_ADMIN))
		to_chat(src, "<span class='warning'>Available only for admins.</span>")
		return

	var/icon/I = icon(target.icon,target.icon_state,target.dir)

	var/orbitsize = (I.Width()+I.Height())*0.5
	orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*0.25)

	var/rot_seg

	switch(ghost_orbit)
		if(GHOST_ORBIT_TRIANGLE)
			rot_seg = 3
		if(GHOST_ORBIT_SQUARE)
			rot_seg = 4
		if(GHOST_ORBIT_PENTAGON)
			rot_seg = 5
		if(GHOST_ORBIT_HEXAGON)
			rot_seg = 6
		else //Circular
			rot_seg = 36 //360/10 bby, smooth enough aproximation of a circle

	orbit(target,orbitsize, FALSE, 20, rot_seg)

/mob/dead/observer/orbit()
	setDir(2)//reset dir so the right directional sprites show up
	return ..()

/mob/dead/observer/stop_orbit(datum/component/orbiter/orbits)
	. = ..()
	//restart our floating animation after orbit is done.
	pixel_y = base_pixel_y
	animate(src, pixel_y = base_pixel_y + 2, time = 1 SECONDS, loop = -1)
	animate(src, pixel_y = base_pixel_y)

/mob/dead/observer/verb/jumptomob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost"
	set name = "Jump to Mob"
	set desc = "Teleport to a mob"

	if(isobserver(usr)) //Make sure they're an observer!
		var/list/dest = list() //List of possible destinations (mobs)
		var/target = null	   //Chosen target.

		if(!check_rights_for(client, R_ADMIN))
			to_chat(src, "<span class='warning'>Available only for admins.</span>")
			return

		dest += getpois(mobs_only = TRUE) //Fill list, prompt user with list
		target = tgui_input_list(src, "Please, select a player!", "Jump to Mob", dest)

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
				to_chat(A, "<span class='danger'>This mob is not located in the game world.</span>")

/mob/dead/observer/verb/change_view_range()
	set category = "Ghost"
	set name = "View Range"
	set desc = "Change your view range."

	var/max_view = client.prefs.unlock_content ? GHOST_MAX_VIEW_RANGE_MEMBER : GHOST_MAX_VIEW_RANGE_DEFAULT
	if(client.view_size.getView() == client.view_size.default)
		var/list/views = list()
		for(var/i in 7 to max_view)
			views |= i
		var/new_view = input("Choose your new view", "Modify view range", 0) as null|anything in views
		if(new_view)
			client.view_size.setTo(clamp(new_view, 7, max_view) - 7)
	else
		client.view_size.resetToDefault()

/mob/dead/observer/verb/add_view_range(input as num)
	set name = "Add View Range"
	set hidden = TRUE
	var/max_view = client.prefs.unlock_content ? GHOST_MAX_VIEW_RANGE_MEMBER : GHOST_MAX_VIEW_RANGE_DEFAULT
	if(input)
		client.rescale_view(input, 0, ((max_view*2)+1) - 15)

/mob/dead/observer/verb/boo()
	set category = "Ghost"
	set name = "Boo!"
	set desc= "Scare citizens because of boredom!"

	if(bootime > world.time)
		return
	var/obj/machinery/light/L = locate(/obj/machinery/light) in view(1, src)
	if(L)
		L.flicker()
		bootime = world.time + 600
		return
	//Maybe in the future we can add more <i>spooky</i> code here!
	return


/mob/dead/observer/memory()
	set hidden = TRUE
	to_chat(src, "<span class='danger'>You are dead! You have no mind to store memory!</span>")

/mob/dead/observer/add_memory()
	set hidden = TRUE
	to_chat(src, "<span class='danger'>You are dead! You have no mind to store memory!</span>")

/mob/dead/observer/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set desc = "Toggles your ability to see things only ghosts can see, like other ghosts"
	set category = "Ghost"
	ghostvision = !(ghostvision)
	update_sight()
	to_chat(usr, "<span class='boldnotice'>You [(ghostvision?"now":"no longer")] have ghost vision.</span>")

/mob/dead/observer/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost"
	switch(lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE

	update_sight()

/mob/dead/observer/update_sight()
	if(client)
		ghost_others = client.prefs.ghost_others //A quick update just in case this setting was changed right before calling the proc

	if (!ghostvision)
		see_invisible = SEE_INVISIBLE_LIVING
	else
		see_invisible = SEE_INVISIBLE_OBSERVER


	updateghostimages()
	..()

/proc/updateallghostimages()
	listclearnulls(GLOB.ghost_images_default)
	listclearnulls(GLOB.ghost_images_simple)

	for (var/mob/dead/observer/O in GLOB.player_list)
		O.updateghostimages()

/mob/dead/observer/proc/updateghostimages()
	if (!client)
		return

	if(lastsetting)
		switch(lastsetting) //checks the setting we last came from, for a little efficiency so we don't try to delete images from the client that it doesn't have anyway
			if(GHOST_OTHERS_DEFAULT_SPRITE)
				client.images -= GLOB.ghost_images_default
			if(GHOST_OTHERS_SIMPLE)
				client.images -= GLOB.ghost_images_simple
	lastsetting = client.prefs.ghost_others
	if(!ghostvision)
		return
	if(client.prefs.ghost_others != GHOST_OTHERS_THEIR_SETTING)
		switch(client.prefs.ghost_others)
			if(GHOST_OTHERS_DEFAULT_SPRITE)
				client.images |= (GLOB.ghost_images_default-ghostimage_default)
			if(GHOST_OTHERS_SIMPLE)
				client.images |= (GLOB.ghost_images_simple-ghostimage_simple)

/mob/dead/observer/verb/possess()
	set category = "Ghost"
	set name = "Possess!"
	set desc= "Take over the body of a mindless creature!"

	if(corpus == 0)
		return

	var/list/possessible = list()
	for(var/mob/living/L in GLOB.alive_mob_list)
		if(istype(L,/mob/living/carbon/human/dummy) || !get_turf(L)) //Haha no.
			continue
		if(!(L in GLOB.player_list) && !L.mind)
			possessible += L

	var/mob/living/target = input("Your new life begins today!", "Possess Mob", null, null) as null|anything in sortNames(possessible)

	if(!target)
		return FALSE

	if(ismegafauna(target))
		to_chat(src, "<span class='warning'>This creature is too powerful for you to possess!</span>")
		return FALSE

	if(can_reenter_corpse && mind?.current)
		if(alert(src, "Your soul is still tied to your former life as [mind.current.name], if you go forward there is no going back to that life. Are you sure you wish to continue?", "Move On", "Yes", "No") == "No")
			return FALSE
	if(target.key)
		to_chat(src, "<span class='warning'>Someone has taken this body while you were choosing!</span>")
		return FALSE

	target.key = key
	target.faction = list("neutral")
	return TRUE

//this is a mob verb instead of atom for performance reasons
//see TYPE_VERB_REF(/mob, examinate)() in mob.dm for more info
//overridden here and in /mob/living for different point span classes and sanity checks
/mob/dead/observer/pointed(atom/A as mob|obj|turf in view(client.view, src))
	if(!..())
		return FALSE
	usr.visible_message("<span class='deadsay'><b>[src]</b> points to [A].</span>")
	return TRUE

/mob/dead/observer/verb/view_manifest()
	set name = "View Crew Manifest"
	set category = "Ghost"

	if(!client)
		return
	if(world.time < client.crew_manifest_delay)
		return
	client.crew_manifest_delay = world.time + (1 SECONDS)
	GLOB.manifest.ui_interact(src)

//this is called when a ghost is drag clicked to something.
/mob/dead/observer/MouseDrop(atom/over)
	if(!usr || !over)
		return
	if (isobserver(usr) && usr.client.holder && (isliving(over) || iscameramob(over)) )
		if (usr.client.holder.cmd_ghost_drag(src,over))
			return

	return ..()

/mob/dead/observer/Topic(href, href_list)
	..()
	if(usr == src)
		if(href_list["follow"])
			var/atom/movable/target = locate(href_list["follow"])
			if(istype(target) && (target != src))
				ManualFollow(target)
				return
		if(href_list["x"] && href_list["y"] && href_list["z"])
			var/tx = text2num(href_list["x"])
			var/ty = text2num(href_list["y"])
			var/tz = text2num(href_list["z"])
			var/turf/target = locate(tx, ty, tz)
			if(istype(target))
				forceMove(target)
				return
		if(href_list["reenter"])
			reenter_corpse()
			return

//We don't want to update the current var
//But we will still carry a mind.
/mob/dead/observer/mind_initialize()
	return

/mob/dead/observer/proc/show_data_huds()
	for(var/hudtype in datahuds)
		var/datum/atom_hud/H = GLOB.huds[hudtype]
		H.add_hud_to(src)

/mob/dead/observer/proc/remove_data_huds()
	for(var/hudtype in datahuds)
		var/datum/atom_hud/H = GLOB.huds[hudtype]
		H.remove_hud_from(src)

/mob/dead/observer/verb/toggle_data_huds()
	set name = "Toggle Sec/Med/Diag HUD"
	set desc = "Toggles whether you see medical/security/diagnostic HUDs"
	set category = "Ghost"

	if(data_huds_on) //remove old huds
		remove_data_huds()
		to_chat(src, "<span class='notice'>Data HUDs disabled.</span>")
		data_huds_on = 0
	else
		show_data_huds()
		to_chat(src, "<span class='notice'>Data HUDs enabled.</span>")
		data_huds_on = 1

/mob/dead/observer/verb/toggle_health_scan()
	set name = "Toggle Health Scan"
	set desc = "Toggles whether you health-scan living beings on click"
	set category = "Ghost"

	if(health_scan) //remove old huds
		to_chat(src, "<span class='notice'>Health scan disabled.</span>")
		health_scan = FALSE
	else
		to_chat(src, "<span class='notice'>Health scan enabled.</span>")
		health_scan = TRUE

/mob/dead/observer/verb/toggle_chem_scan()
	set name = "Toggle Chem Scan"
	set desc = "Toggles whether you scan living beings for chemicals and addictions on click"
	set category = "Ghost"

	if(chem_scan) //remove old huds
		to_chat(src, "<span class='notice'>Chem scan disabled.</span>")
		chem_scan = FALSE
	else
		to_chat(src, "<span class='notice'>Chem scan enabled.</span>")
		chem_scan = TRUE

/mob/dead/observer/verb/toggle_gas_scan()
	set name = "Toggle Gas Scan"
	set desc = "Toggles whether you analyze gas contents on click"
	set category = "Ghost"

	if(gas_scan)
		to_chat(src, "<span class='notice'>Gas scan disabled.</span>")
		gas_scan = FALSE
	else
		to_chat(src, "<span class='notice'>Gas scan enabled.</span>")
		gas_scan = TRUE

/mob/dead/observer/verb/restore_ghost_appearance()
	set name = "Restore Ghost Character"
	set desc = "Sets your deadchat name and ghost appearance to your \
		roundstart character."
	set category = "Ghost"

	set_ghost_appearance()
	if(client?.prefs)
		deadchat_name = client.prefs.real_name
		if(mind)
			mind.ghostname = client.prefs.real_name
		name = client.prefs.real_name

/mob/dead/observer/proc/set_ghost_appearance()
	if((!client) || (!client.prefs))
		return

	if(client.prefs.randomise[RANDOM_NAME])
		client.prefs.real_name = random_unique_name(gender)
	if(client.prefs.randomise[RANDOM_BODY])
		client.prefs.random_character(gender)

	if(HAIR in client.prefs.pref_species.species_traits)
		hairstyle = client.prefs.hairstyle
		hair_color = brighten_color(client.prefs.hair_color)
	if(FACEHAIR in client.prefs.pref_species.species_traits)
		facial_hairstyle = client.prefs.facial_hairstyle
		facial_hair_color = brighten_color(client.prefs.facial_hair_color)

	update_icon()

/mob/dead/observer/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE, need_hands = FALSE, floor_okay=FALSE)
	return isAdminGhostAI(usr)

/mob/dead/observer/is_literate()
	return TRUE

/mob/dead/observer/vv_edit_var(var_name, var_value)
	. = ..()
	switch(var_name)
		if(NAMEOF(src, icon))
			ghostimage_default.icon = icon
			ghostimage_simple.icon = icon
		if(NAMEOF(src, icon_state))
			ghostimage_default.icon_state = icon_state
			ghostimage_simple.icon_state = icon_state
		if(NAMEOF(src, fun_verbs))
			if(fun_verbs)
				add_verb(src, /mob/dead/observer/verb/boo)
				add_verb(src, /mob/dead/observer/verb/possess)
			else
				remove_verb(src, /mob/dead/observer/verb/boo)
				remove_verb(src, /mob/dead/observer/verb/possess)

/mob/dead/observer/reset_perspective(atom/A)
	if(client)
		if(ismob(client.eye) && (client.eye != src))
			var/mob/target = client.eye
			observetarget = null
			if(target.observers)
				target.observers -= src
				UNSETEMPTY(target.observers)
	if(..())
		if(hud_used)
			client.screen = list()
			hud_used.show_hud(hud_used.hud_version)

/mob/dead/observer/verb/observe()
	set name = "Observe"
	set category = "Ghost"

	var/list/creatures = getpois()

	reset_perspective(null)

	var/eye_name = null

	eye_name = input("Please, select a player!", "Observe", null, null) as null|anything in creatures

	if (!eye_name)
		return

	do_observe(creatures[eye_name])

/mob/dead/observer/proc/do_observe(mob/mob_eye)
	//Istype so we filter out points of interest that are not mobs
	if(client && mob_eye && istype(mob_eye))
		client.eye = mob_eye
		if(mob_eye.hud_used)
			client.screen = list()
			LAZYINITLIST(mob_eye.observers)
			mob_eye.observers |= src
			mob_eye.hud_used.show_hud(mob_eye.hud_used.hud_version, src)
			observetarget = mob_eye

/mob/dead/observer/verb/register_pai_candidate()
	set category = "Ghost"
	set name = "pAI Setup"
	set desc = "Upload a fragment of your personality to the global pAI databanks"

	register_pai()

/mob/dead/observer/proc/register_pai()
	if(isobserver(src))
		SSpai.recruitWindow(src)
	else
		to_chat(usr, "<span class='warning'>Can't become a pAI candidate while not dead!</span>")

/mob/dead/observer/CtrlShiftClick(mob/user)
	if(isobserver(user) && check_rights(R_SPAWN))
		change_mob_type( /mob/living/carbon/human , null, null, TRUE) //always delmob, ghosts shouldn't be left lingering

/mob/dead/observer/examine(mob/user)
	. = ..()
	if(!invisibility)
		. += "It seems extremely obvious."

/mob/dead/observer/examine_more(mob/user)
	if(!isAdminObserver(user))
		return ..()
	. = list("<span class='notice'><i>You examine [src] closer, and note the following...</i></span>")
	. += list("\t><span class='admin'>[ADMIN_FULLMONTY(src)]</span>")


/mob/dead/observer/proc/set_invisibility(value)
	invisibility = value
	set_light_on(!value ? TRUE : FALSE)


// Ghosts have no momentum, being massless ectoplasm
/mob/dead/observer/Process_Spacemove(movement_dir)
	return TRUE

/mob/dead/observer/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == NAMEOF(src, invisibility))
		set_invisibility(invisibility) // updates light

/proc/set_observer_default_invisibility(amount, message=null)
	for(var/mob/dead/observer/G in GLOB.player_list)
		G.set_invisibility(amount)
		if(message)
			to_chat(G, message)
	GLOB.observer_default_invisibility = amount

/mob/dead/observer/proc/open_spawners_menu()
	set name = "Spawners Menu"
	set desc = "See all currently available spawners"
	set category = "Ghost"
	if(!spawners_menu)
		spawners_menu = new(src)

	spawners_menu.ui_interact(src)

/mob/dead/observer/proc/tray_view()
	set category = "Ghost"
	set name = "T-ray view"
	set desc = "Toggles a view of sub-floor objects"

	var/static/t_ray_view = FALSE
	t_ray_view = !t_ray_view

	var/list/t_ray_images = list()
	var/static/list/stored_t_ray_images = list()
	for(var/obj/O in orange(client.view, src) )
		if(HAS_TRAIT(O, TRAIT_T_RAY_VISIBLE))
			var/image/I = new(loc = get_turf(O))
			var/mutable_appearance/MA = new(O)
			MA.alpha = 128
			MA.dir = O.dir
			I.appearance = MA
			t_ray_images += I
	stored_t_ray_images += t_ray_images
	if(t_ray_images.len)
		if(t_ray_view)
			client.images += t_ray_images
		else
			client.images -= stored_t_ray_images

/mob/dead/observer/proc/update_ghost_hud()
	if(!hud_list || !hud_list[GHOST_HUD])
		return
	var/image/holder = hud_list[GHOST_HUD]
	holder.icon = icon
	holder.icon_state = icon_state
	holder.alpha = 180
	holder.color = "#ffffff"
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
