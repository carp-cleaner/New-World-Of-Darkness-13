/mob/proc/intro_Sperma(text, time, rgb)
//rgb(r, g, b)
	if(!mind)
		return
	if(!client)
		return
	if(time == null)
		time = 10
	if(rgb == null)
		rgb = rgb(158, 3, 3)
	var/obj/screen/Kon4a_text/T = new()
	client.screen += T
	T.maptext = {"<span style='vertical-align:top; text-align:center;
				color:[rgb]; font-size: 300%;
				text-shadow: 1px 1px 2px black, 0 0 1em black, 0 0 0.2em black;
				font-family: "Blackmoor LET", "Pterra";'>[text]</span>"}
	T.maptext_width = 205
	T.maptext_height = 209
	T.maptext_x = 12
	T.maptext_y = 64
	playsound_local(src, 'code/modules/wod13/sounds/domination.ogg', 100, FALSE)
	animate(T, alpha = 255, time = time, easing = EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(clear_Sperma_text), T), 35)

/mob/proc/clear_Sperma_text(obj/screen/A)
	if(!A)
		return
	if(!client)
		return
	animate(A, alpha = 0, time = 10, easing = EASE_OUT)
	sleep(11)
	if(client)
		if(client.screen && A)
			client.screen -= A
			qdel(A)

/obj/screen/Kon4a_text
	icon = null
	icon_state = ""
	name = ""
	screen_loc = "5,5"
	layer = HUD_LAYER+0.02
	plane = HUD_PLANE
	alpha = 0
	var/reading

/client/proc/text_to_all()
	set name = "Global screen text"
	set category = "Admin.Fun"
	set desc = "This should be helpfull for testing purposes"

//	var/list/to_who = list("Всем", "Камарилья", "Шабаш", "Анархи")
	var/novii_text = input(src, "Что вы хотите написать:", "Глобальный текст")  as text|null
	if(!novii_text)
		return

	for(var/i in GLOB.player_list)
		var/mob/M = i
		M.intro_Sperma(novii_text)

/mob/proc/into_fisheye()
	var/obj/screen/fullscreen/fisheye/F = new()
	client.screen += F
	animate(F, alpha = 255, time = 10, easing = EASE_IN)

/obj/screen/fullscreen/fisheye
	icon = null
	icon_state = ""
	name = ""
	screen_loc = "5,5"
	layer = HUD_LAYER+0.02
	plane = HUD_PLANE
	alpha = 0
	var/atom/movable/screen/fullscreen/warp_effect/warp


/obj/screen/fullscreen/fisheye/Initialize(mapload)
	. = ..()
	apply_wibbly_filters(src, 20)

	warp = new(src)
	vis_contents += warp

/obj/screen/fullscreen/fisheye/Destroy()
	vis_contents -= warp
	warp = null
	return ..()

/atom/movable/screen/fullscreen/warp_effect
	plane = FULLSCREEN_PLANE
	appearance_flags = PIXEL_SCALE|LONG_GLIDE // no tile bound so you can see it around corners and so
	icon = 'icons/effects/light_overlays/light_352.dmi'
	icon_state = "light"
	pixel_x = -176
	pixel_y = -176

/atom/movable/screen/fullscreen/badtrip
	icon = 'icons/hud/fullscreen.dmi'
	icon_state = "hohol_trip"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/badtrip/Initialize(mapload)
	. = ..()
	dir = pick( EAST, WEST, SOUTHWEST, NORTHEAST)

/atom/movable/screen/fullscreen/niggatrip
	icon = 'icons/hud/fullscreen.dmi'
	icon_state = "hohol_trip"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/niggatrip/Initialize(mapload)
	. = ..()
	dir = pick(NORTH, EAST, WEST, SOUTH, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/mob/proc/polnii_pizdec()
	if(!client)
		return
	var/obj/screen/fullscreen/fisheye/F = new()
	client.screen += F
	overlay_fullscreen("BADTRIP", /atom/movable/screen/fullscreen/badtrip)
	clear_fullscreen("BADTRIP", 5)
	var/list/screens = list(hud_used.plane_masters["[FLOOR_PLANE]"], hud_used.plane_masters["[GAME_PLANE]"], hud_used.plane_masters["[LIGHTING_PLANE]"])
	var/rotation = 150
	for(var/atom/whole_screen in screens)
	//	animate(whole_screen, transform = warp, time=5, easing = QUAD_EASING )
		animate(whole_screen, transform = matrix(rotation, MATRIX_ROTATE), time = 1.0 SECONDS, easing = QUAD_EASING, loop = -1)
		animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 1.0 SECONDS, easing = QUAD_EASING)
		for(var/i in 1 to 7)
			whole_screen.add_filter("wibbly-[i]", 5, wave_filter(x = 350, y = 200, size =25, offset = rand()))
//	addtimer(CALLBACK(src, PROC_REF(polnii_GOI), F), 35)

/*
/mob/proc/polnii_GOI(obj/screen/A, atom/in_atom)
	var/list/screens = list(hud_used.plane_masters["[FLOOR_PLANE]"], hud_used.plane_masters["[GAME_PLANE]"], hud_used.plane_masters["[LIGHTING_PLANE]"])
	for(var/whole_screen in screens)
		animate(whole_screen, transform = matrix(), time = 1.0 SECONDS, easing = QUAD_EASING)
		remove_wibbly_filters(whole_screen)
	var/filter
	for(var/i in 1 to 7)
		filter = in_atom.get_filter("wibbly-[i]")
		animate(filter)
		in_atom.remove_filter("wibbly-[i]")
	if(!A)
		return
	if(!client)
		return
	animate(A, alpha = 0, time = 10, easing = EASE_OUT)
	sleep(11)
	if(client)
		if(client.screen && A)
			client.screen -= A
			qdel(A)


/mob/proc/hud_color_filter()
	//this is RGB, not anything else
//	var/obj/hud_plane_master
	var/list/screens = list(hud_used.plane_masters["[LIGHTING_PLANE]"])
	var/static/list/col_filter_identity = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	var/static/list/col_filter_purple = list(1,0,0,0, 0.6,0.3,0.6,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	var/static/list/col_filter_blue = list(1,0,0,0, 0.1,0.2,0.9,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	hud_used.filters += filter(type = "color", color = col_filter_identity)
	var/color_filter = hud_used.filters[length(hud_used.filters)]
	animate(color_filter, color = col_filter_identity, time = 0 SECONDS, loop = -1, flags = ANIMATION_PARALLEL)
	animate(color = col_filter_purple, time = 6 SECONDS)
	animate(color = col_filter_blue, time = 4 SECONDS)
	animate(color = col_filter_identity, time = 2 SECONDS)
*/
