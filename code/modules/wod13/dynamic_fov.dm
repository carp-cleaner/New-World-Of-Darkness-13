#define ATOMS_FOV_SHADOWS_PLANE 21
#define WALLS_FOV_PLANE_0 23
#define WALLS_FOV_PLANE_1 24
#define WALLS_FOV_PLANE_2 25

#define ATOMS_FOV_SHADOWS_RENDER_TARGET "*ATOMS_FOV_SHADOWS_PLANE"
#define WALLS_FOV_PLANE_0_RENDER_TARGET "*WALLS_FOV_PLANE_0"
#define WALLS_FOV_PLANE_1_RENDER_TARGET "*WALLS_FOV_PLANE_1"

/atom/movable/atom_shadow
	name = "shadow"
	icon = 'code/modules/wod13/icons/shadow.dmi'
	icon_state = "shadow"
	plane = ATOMS_FOV_SHADOWS_PLANE
	mouse_opacity = 1

/atom/movable/screen/walls
	screen_loc = "CENTER"
	plane = -1

/atom/movable/screen/wall_fov
	screen_loc = "CENTER"
	alpha = 255
	appearance_flags = PLANE_MASTER|PASS_MOUSE

/atom/movable/screen/wall_fov/shadows_plane
	name = "wall fov shadows plane"
	plane = ATOMS_FOV_SHADOWS_PLANE
	render_target = ATOMS_FOV_SHADOWS_RENDER_TARGET

/atom/movable/screen/wall_fov/plane0
	name = "wall fov plane0"
	plane = WALLS_FOV_PLANE_0
	render_target = WALLS_FOV_PLANE_0_RENDER_TARGET

/atom/movable/screen/wall_fov/plane0/New(client/user)
	. = ..()
	filters += filter(type = "layer", render_source = ATOMS_FOV_SHADOWS_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", x = 64, icon = icon('code/modules/wod13/icons/walls_fov.dmi', "1"), size = 1, flags = FILTER_OVERLAY)
	filters += filter(type = "alpha", render_source = ATOMS_FOV_SHADOWS_RENDER_TARGET, flags = MASK_INVERSE)

/atom/movable/screen/wall_fov/plane1
	name = "wall fov plane1"
	plane = WALLS_FOV_PLANE_1

	render_target = WALLS_FOV_PLANE_1_RENDER_TARGET

/atom/movable/screen/wall_fov/plane1/New(client/user)
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_0_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", x = 64, icon = icon('code/modules/wod13/icons/walls_fov.dmi', "1"), size = 1, flags = FILTER_OVERLAY)
	filters += filter(type = "displace", x = 64, icon = icon('code/modules/wod13/icons/walls_fov.dmi', "2"), size = 2, flags = FILTER_OVERLAY)
	filters += filter(type = "displace", x = 64, icon = icon('code/modules/wod13/icons/walls_fov.dmi', "3"), size = 4, flags = FILTER_OVERLAY)
	filters += filter(type = "displace", x = 64, icon = icon('code/modules/wod13/icons/walls_fov.dmi', "4"), size = 8, flags = FILTER_OVERLAY)
	filters += filter(type = "displace", x = 64, icon = icon('code/modules/wod13/icons/walls_fov.dmi', "5"), size = 16, flags = FILTER_OVERLAY)
	filters += filter(type = "displace", x = 64, icon = icon('code/modules/wod13/icons/walls_fov.dmi', "6"), size = 32, flags = FILTER_OVERLAY)
	filters += filter(type = "displace", x = 64, icon = icon('code/modules/wod13/icons/walls_fov.dmi', "7"), size = 64, flags = FILTER_OVERLAY)
	filters += filter(type = "displace", x = 64, icon = icon('code/modules/wod13/icons/walls_fov.dmi', "8"), size = 128, flags = FILTER_OVERLAY)
	filters += filter(type = "displace", x = 64, icon = icon('code/modules/wod13/icons/walls_fov.dmi', "9"), size = 128, flags = FILTER_OVERLAY)

	filters += filter(type = "drop_shadow", size = 12, color = "#000000")
	filters += filter(type = "blur", size = 4)
///

/atom/movable/screen/wall_fov/plane2
	name = "wall fov plane2"
	plane = WALLS_FOV_PLANE_2
//	alpha = 100
//	color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,2)

/atom/movable/screen/wall_fov/plane2/New(client/user)
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_1_RENDER_TARGET, flags = FILTER_UNDERLAY)


/mob/living/Login()

	. = ..()

	add_fovik()

/mob/living/proc/add_fovik()
	for(var/plane in typesof(/atom/movable/screen/wall_fov) - /atom/movable/screen/wall_fov)
		var/atom/movable/screen/PM = new plane(client)
		client.screen += PM

	client.screen += new /atom/movable/screen/walls


/mob/living/proc/remove_fovik()
	for(var/plane in client.screen)
		if(istype(plane, /atom/movable/screen/wall_fov))
			client.screen -= plane
		if(istype(plane,/atom/movable/screen/walls))
			client.screen -= plane

/datum/discipline_power/auspex/heightened_senses/activate()
	. = ..()
	owner.remove_fovik()

/datum/discipline_power/auspex/heightened_senses/deactivate()
	. = ..()
	owner.add_fovik()


/turf/closed/wall
	var/atom/movable/atom_shadow/SHDW

/turf/closed/wall/New()
	. = ..()
	if(opacity)
		SHDW = new /atom/movable/atom_shadow(src)

/turf/closed/wall/Destroy()
	. = ..()
	if(SHDW)
		qdel(SHDW)
/*
/obj/structure/vampdoor
	var/atom/movable/atom_shadow/AS

/obj/structure/vampdoor/New()
	. = ..()
	if(closed)
		AS = new /atom/movable/atom_shadow()

/obj/structure/vampdoor/proc/check_fov()
	if(opacity)
		AS.alpha = 255
	else
		AS.alpha = 0
		*/




///////////////// REAL SHADOWS /////////////////////
