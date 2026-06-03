//Smooth Operator soset biby

/obj/effect/addwall
	name = "Debug"
	desc = "First rule of debug placeholder: Do not talk about debug placeholder."
	icon = 'code/modules/wod13/addwalls.dmi'
	base_icon_state = "wall"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYERS_LAYER
	anchored = TRUE
	mouse_opacity = 0
//	vis_flags = VIS_HIDE

/obj/effect/addwall/Crossed(atom/movable/AM, oldloc)
	. = ..()
	var/someoneshere = FALSE
	for(var/mob/living/L in get_turf(src))
		if(L)
			someoneshere = TRUE
	if(!someoneshere)
		alpha = 255
	else
		alpha = 128

/obj/effect/addwall/Uncrossed(atom/movable/AM)
	. = ..()
	var/someoneshere = FALSE
	for(var/mob/living/L in get_turf(src))
		if(L)
			someoneshere = TRUE
	if(!someoneshere)
		alpha = 255
	else
		alpha = 128

/turf/closed/wall/vampwall
	name = "old brick wall"
	desc = "A huge chunk of old bricks used to separate rooms."
	icon = 'code/modules/wod13/walls.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	opacity = TRUE
	density = TRUE
	smoothing_flags = SMOOTH_BITMASK

	var/obj/effect/addwall/addwall
	var/low = FALSE
	var/window

/turf/closed/wall/vampwall/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(low)
		if(.)
			return
		if(istype(mover) && (mover.pass_flags & PASSTABLE))
			return TRUE
		if(istype(mover.loc, /turf/closed/wall/vampwall)) //Because "low" type walls aren't standardized and are subtypes of different wall types
			var/turf/closed/wall/vampwall/vw = mover.loc
			if(vw.low)
				return TRUE
		//Roughly the same elevation
		if(locate(/obj/structure/table) in get_turf(mover))
			return TRUE

/turf/closed/wall/vampwall/attackby(obj/item/W, mob/user, params)
	return

/turf/closed/wall/vampwall/attack_hand(mob/user)
	return

/turf/closed/wall/vampwall/ex_act(severity, target)
	return

/turf/closed/wall/vampwall/Initialize(mapload)
	..()
	if(window)
		var/obj/W = new window(src)
		W.plane = GAME_PLANE
		W.layer = ABOVE_ALL_MOB_LAYER
	else if(!low)
		addwall = new(get_step(src, NORTH))
		addwall.icon_state = icon_state
		addwall.name = name
		addwall.desc = desc

	if(low)
		AddElement(/datum/element/climbable)

/turf/closed/wall/vampwall/set_smoothed_icon_state(new_junction)
	..()
	if(addwall)
		addwall.icon_state = icon_state

/turf/closed/wall/vampwall/Destroy()
	..()
	if(addwall)
		qdel(addwall)

/turf/closed/wall/vampwall/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE //Let the windows block the air transfer

//TURFS

/obj/effect/decal/asphalt
	name = "asphalt"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "decal1"
	mouse_opacity = 0

/obj/effect/decal/asphalt/Initialize(mapload)
	..()
	icon_state = "decal[rand(1, 24)]"
	update_icon()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				alpha = 25

/obj/effect/decal/snow_overlay
	name = "snow"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "snow_overlay"
	alpha = 200
	mouse_opacity = 0

/obj/effect/decal/asphaltline
	name = "asphalt"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "line"
	mouse_opacity = 0

/obj/effect/decal/asphaltline/alt
	icon_state = "line_alt"

/obj/effect/decal/asphaltline/Initialize(mapload)
	..()
	icon_state = "[initial(icon_state)][rand(1, 3)]"
	update_icon()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)][rand(1, 3)]-snow"

/obj/effect/decal/crosswalk
	name = "asphalt"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "crosswalk1"
	mouse_opacity = 0

/obj/effect/decal/crosswalk/Initialize(mapload)
	..()
	icon_state = "crosswalk[rand(1, 3)]"
	update_icon()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "crosswalk[rand(1, 3)]-snow"

/turf/open/floor/plating/asphalt
	gender = PLURAL
	name = "asphalt"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "asphalt1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_ASPHALT
	barefootstep = FOOTSTEP_ASPHALT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/asphalt/Initialize(mapload)
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				new /obj/effect/decal/snow_overlay(src)
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW
	if(prob(50))
		icon_state = "asphalt[rand(1, 3)]"
		update_icon()
	if(prob(25))
		new /obj/effect/decal/asphalt(src)
	set_light(1, 0.2, "#a4b7ff")

/turf/open/floor/plating/asphalt/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/asphalt/ex_act(severity, target)
	contents_explosion(severity, target)

/obj/effect/decal/stock
	name = "stock"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "stock"
	mouse_opacity = 0

/obj/effect/decal/ventilation_system
	name = "ventilation"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "vents"
	mouse_opacity = 0
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE

/turf/open/floor/plating/sidewalkalt
	gender = PLURAL
	name = "sidewalk"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "sidewalk_alt1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/sidewalkalt/Initialize(mapload)
	. = ..()
	icon_state = "sidewalk_alt[rand(1, 4)]"
	set_light(1, 0.2, "#a4b7ff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/sidewalk
	gender = PLURAL
	name = "sidewalk"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "sidewalk1"
	var/number_of_variations = 3
	var/based_icon_state = "sidewalk"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	var/brokenwalk = TRUE

/turf/open/floor/plating/sidewalk/Initialize(mapload)
	. = ..()
	icon_state = "[based_icon_state][rand(1, number_of_variations)]"
	if(brokenwalk)
		if(prob(5))
			icon_state = "brokenwalk[rand(1, 3)]"
	set_light(1, 0.2, "#a4b7ff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/sidewalk/poor
	icon_state = "sidewalk_poor1"
	based_icon_state = "sidewalk_poor"
	brokenwalk = FALSE

/turf/open/floor/plating/sidewalk/rich
	icon_state = "sidewalk_rich1"
	number_of_variations = 6
	based_icon_state = "sidewalk_rich"
	brokenwalk = FALSE

/turf/open/floor/plating/sidewalk/old
	icon_state = "sidewalk_old1"
	number_of_variations = 4
	based_icon_state = "sidewalk_old"
	brokenwalk = FALSE

/turf/open/floor/plating/roofwalk
	gender = PLURAL
	name = "roof"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "roof"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/roofwalk/Initialize(mapload)
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

//Airless version of this because they are used as a z-level 4 roof on a z-level 3 building, and since they aren't meant to be reached...
/turf/open/floor/plating/roofwalk/no_air
	blocks_air = 1

/obj/effect/decal/bordur
	name = "sidewalk"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "border"
	mouse_opacity = 0

/obj/effect/decal/bordur/Initialize(mapload)
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"
//				footstep = FOOTSTEP_SNOW
//				barefootstep = FOOTSTEP_SNOW
//				clawfootstep = FOOTSTEP_SNOW
//				heavyfootstep = FOOTSTEP_SNOW

/obj/effect/decal/daroof
	name = "roof"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "roof"
	mouse_opacity = 0
	anchored = TRUE
	density = FALSE
	obj_flags = BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	turf_loc_check = FALSE

/obj/effect/decal/daroof/red
	icon_state = "roof_red"

/obj/effect/decal/daroof/blue
	icon_state = "roof_blue"

/obj/effect/decal/daroof/gray
	icon_state = "roof_gray"

/obj/effect/decal/bordur/corner
	icon_state = "border_corner"

//OTHER TURFS

/turf/open/floor/plating/parquetry
	gender = PLURAL
	name = "parquetry"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "parquet"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/parquetry/old
	icon_state = "parquet-old"

/turf/open/floor/plating/parquetry/rich
	icon_state = "parquet-rich"

/turf/open/floor/plating/granite
	gender = PLURAL
	name = "granite"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "granite"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/granite/black
	icon_state = "granite-black"

/turf/open/floor/plating/concrete
	gender = PLURAL
	name = "concrete"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "concrete1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/concrete/Initialize(mapload)
	..()
	icon_state = "concrete[rand(1, 4)]"

/turf/open/floor/plating/vampgrass
	gender = PLURAL
	name = "grass"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "grass1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TRAVA
	barefootstep = FOOTSTEP_TRAVA
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampgrass/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/melee/vampirearms/shovel))
		var/obj/structure/bury_pit/P = locate() in src
		if(P)
			if(!P.burying)
				P.burying = TRUE
				user.visible_message("<span class='warning'>[user] starts to dig [src]</span>", "<span class='warning'>You start to dig [src].</span>")
				if(do_mob(user, src, 10 SECONDS))
					P.burying = FALSE
					if(P.icon_state == "pit0")
						var/dead_amongst = FALSE
						for(var/mob/living/L in src)
							L.forceMove(P)
							if(L.stat == DEAD)
								dead_amongst = TRUE
						P.icon_state = "pit1"
						user.visible_message("<span class='warning'>[user] digs a hole in [src].</span>", "<span class='warning'>You dig a hole in [src].</span>")
						if(dead_amongst)
							call_dharma("respect", user)
					else
						var/dead_amongst = FALSE
						for(var/mob/living/L in P)
							L.forceMove(src)
							if(L.stat == DEAD)
								dead_amongst = TRUE
						P.icon_state = "pit0"
						user.visible_message("<span class='warning'>[user] digs a hole in [src].</span>", "<span class='warning'>You dig a hole in [src].</span>")
						if(dead_amongst)
							call_dharma("disrespect", user)
				else
					P.burying = FALSE
		else
			user.visible_message("<span class='warning'>[user] starts to dig [src]</span>", "<span class='warning'>You start to dig [src].</span>")
			if(do_mob(user, src, 10 SECONDS))
				if(!locate(/obj/structure/bury_pit) in src)
					user.visible_message("<span class='warning'>[user] digs a hole in [src].</span>", "<span class='warning'>You dig a hole in [src].</span>")
					new /obj/structure/bury_pit(src)


/turf/open/floor/plating/vampgrass/Initialize(mapload)
	..()
	set_light(1, 0.2, "#a4b7ff")
	icon_state = "grass[rand(1, 3)]"
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/vampcarpet
	gender = PLURAL
	name = "carpet"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "carpet_black"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampcarpet/ship
	icon = 'code/modules/wod13/ship/floor.dmi'
	icon_state = "cover"

/turf/open/floor/plating/vampdirt
	gender = PLURAL
	name = "dirt"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "dirt"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_ASPHALT
	barefootstep = FOOTSTEP_ASPHALT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampdirt/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/melee/vampirearms/shovel))
		var/obj/structure/bury_pit/P = locate() in src
		if(P)
			if(!P.burying)
				P.burying = TRUE
				user.visible_message("<span class='warning'>[user] starts to dig [src]</span>", "<span class='warning'>You start to dig [src].</span>")
				if(do_mob(user, src, 10 SECONDS))
					P.burying = FALSE
					if(P.icon_state == "pit0")
						var/dead_amongst = FALSE
						for(var/mob/living/L in src)
							L.forceMove(P)
							if(L.stat == DEAD)
								dead_amongst = TRUE
						P.icon_state = "pit1"
						user.visible_message("<span class='warning'>[user] digs a hole in [src].</span>", "<span class='warning'>You dig a hole in [src].</span>")
						if(dead_amongst)
							call_dharma("respect", user)
					else
						var/dead_amongst = FALSE
						for(var/mob/living/L in P)
							L.forceMove(src)
							if(L.stat == DEAD)
								dead_amongst = TRUE
						P.icon_state = "pit0"
						user.visible_message("<span class='warning'>[user] digs a hole in [src].</span>", "<span class='warning'>You dig a hole in [src].</span>")
						if(dead_amongst)
							call_dharma("disrespect", user)
				else
					P.burying = FALSE
		else
			user.visible_message("<span class='warning'>[user] starts to dig [src]</span>", "<span class='warning'>You start to dig [src].</span>")
			if(do_mob(user, src, 10 SECONDS))
				if(!locate(/obj/structure/bury_pit) in src)
					user.visible_message("<span class='warning'>[user] digs a hole in [src].</span>", "<span class='warning'>You dig a hole in [src].</span>")
					new /obj/structure/bury_pit(src)

/turf/open/floor/plating/vampdirt/Initialize(mapload)
	. = ..()
	set_light(1, 0.2, "#a4b7ff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/vampdirt/rails
	name = "rails"
	icon_state = "dirt_rails"

/turf/open/floor/plating/vampdirt/rails/Initialize(mapload)
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow_rails"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/vampplating
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "plating"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampplating/mono
	icon_state = "plating-mono"

/turf/open/floor/plating/vampplating/stone
	icon_state = "plating-stone"

/turf/open/floor/plating/rough
	gender = PLURAL
	name = "rough floor"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "rough"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/rough/cave
	icon_state = "cave1"

/turf/open/floor/plating/rough/cave/Initialize(mapload)
	. = ..()
	icon_state = "cave[rand(1, 7)]"

/turf/open/floor/plating/stone
	gender = PLURAL
	name = "rough floor"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "stone"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/stone
	icon_state = "stone1"

/turf/open/floor/plating/stone/Initialize(mapload)
	.=..()
	icon_state = "cave[rand(1, 7)]"

/turf/open/floor/plating/toilet
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "toilet1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/toilet/Initialize(mapload)
	..()
	icon_state = "toilet[rand(1, 9)]"

/turf/open/floor/plating/circled
	gender = PLURAL
	name = "fancy plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "circle1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/circled/Initialize(mapload)
	..()
	icon_state = "circle[rand(1, 8)]"

/turf/open/floor/plating/church
	gender = PLURAL
	name = "fancy plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "church1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/church/Initialize(mapload)
	..()
	icon_state = "church[rand(1, 4)]"

/turf/open/floor/plating/saint
	gender = PLURAL
	name = "fancy plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "saint1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/saint/Initialize(mapload)
	..()
	icon_state = "saint[rand(1, 2)]"

//OBOI

/obj/effect/decal/wallpaper
	name = "wall paint"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "wallpaper"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER	//WALLPAPER_LAYER dont work

/obj/effect/decal/wallpaper/Initialize(mapload)
	..()
	if(isclosedturf(loc))
		forceMove(get_step(src, SOUTH))
		pixel_y = 32

/turf/open/floor/plating/vampwood
	gender = PLURAL
	name = "wood"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "bwood"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampwood/Initialize(mapload)
	..()
	set_light(1, 0.2, "#a4b7ff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/vampbeach
	gender = PLURAL
	name = "sand"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "sand1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampbeach/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/melee/vampirearms/shovel))
		var/obj/structure/bury_pit/P = locate() in src
		if(P)
			if(!P.burying)
				P.burying = TRUE
				user.visible_message("<span class='warning'>[user] starts to dig [src]</span>", "<span class='warning'>You start to dig [src].</span>")
				if(do_mob(user, src, 10 SECONDS))
					P.burying = FALSE
					if(P.icon_state == "pit0")
						var/dead_amongst = FALSE
						for(var/mob/living/L in src)
							L.forceMove(P)
							if(L.stat == DEAD)
								dead_amongst = TRUE
						P.icon_state = "pit1"
						user.visible_message("<span class='warning'>[user] digs a hole in [src].</span>", "<span class='warning'>You dig a hole in [src].</span>")
						if(dead_amongst)
							call_dharma("respect", user)
					else
						var/dead_amongst = FALSE
						for(var/mob/living/L in P)
							L.forceMove(src)
							if(L.stat == DEAD)
								dead_amongst = TRUE
						P.icon_state = "pit0"
						user.visible_message("<span class='warning'>[user] digs a hole in [src].</span>", "<span class='warning'>You dig a hole in [src].</span>")
						if(dead_amongst)
							call_dharma("disrespect", user)
				else
					P.burying = FALSE
		else
			user.visible_message("<span class='warning'>[user] starts to dig [src]</span>", "<span class='warning'>You start to dig [src].</span>")
			if(do_mob(user, src, 10 SECONDS))
				if(!locate(/obj/structure/bury_pit) in src)
					user.visible_message("<span class='warning'>[user] digs a hole in [src].</span>", "<span class='warning'>You dig a hole in [src].</span>")
					new /obj/structure/bury_pit(src)

/turf/open/floor/plating/vampbeach/Initialize(mapload)
	..()
	icon_state = "sand[rand(1, 4)]"
	set_light(1, 0.2, "#a4b7ff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "snow[rand(1, 14)]"

/turf/open/floor/plating/vampocean
	gender = PLURAL
	name = "water"
	icon = 'icons/turf/water.dmi'
	icon_state = "0,0"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	density = FALSE

/turf/open/floor/plating/vampocean/Enter(atom/movable/mover, atom/oldloc)
	if(isliving(mover))
		var/mob/living/swimmer = mover
		if(!HAS_TRAIT(swimmer, TRAIT_SUPERNATURAL_DEXTERITY))
			return FALSE
	. = ..()

/turf/open/floor/plating/vampocean/Initialize(mapload)
	. = ..()
//	var/myx = 0
//	if(x/5 == round(x/5))
//		myx = 0
//	var/myy = 0
	color = "#414141"
	icon_state = "[(x - 1) % 5],[(y - 1) % 2]"
	set_light(1, 0.2, "#a4b7ff")

/turf/open/floor/plating/vampacid
	gender = PLURAL
	name = "goop"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "acid"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	density = FALSE

/turf/open/floor/plating/vampacid/Initialize(mapload)
	..()
	set_light(1, 0.5, "#1b7c4c")


/turf/open/floor/plating/vampacid/Entered(atom/movable/AM)
	if(acid_burn(AM))
		START_PROCESSING(SSobj, src)

/turf/open/floor/plating/vampacid/proc/acid_burn(mob/living/L)
	if(isliving(L))
		if(L.movement_type & FLYING)
			return
		L.apply_damage(10, CLONE)
		L.apply_damage(30, TOX)
		to_chat(L, "<span class='warning'>Your flesh burns!</span>")

/obj/effect/decal/coastline
	name = "water"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "coastline"

/obj/effect/decal/coastline/corner
	icon_state = "coastline_corner"

/obj/effect/decal/shadow
	name = "shadow"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "shadow"

/obj/effect/decal/shadow/Initialize(mapload)
	. = ..()
	if(istype(loc, /turf/open/openspace))
		forceMove(get_step(src, NORTH))
		pixel_y = -32

/obj/effect/decal/support
	name = "support"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "support"

/turf/open/floor/plating/shit
	gender = PLURAL
	name = "sewage"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "shit"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

/*
/turf/open/floor/plating/shit/Initialize(mapload)
	. = ..()
	if(prob(50))
		new /obj/effect/realistic_fog(src)
*/

/turf/open/floor/plating/shit/border
	icon_state = "shit_border"

/turf/open/floor/plating/vampcanal
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "canal1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampcanal/Enter(atom/movable/mover, atom/oldloc)
	. = ..()
	if(istype(mover, /mob/living/carbon/human))
		var/mob/living/L = mover
		if(L.client)
			if(prob(10))
				new /mob/living/simple_animal/pet/rat(oldloc)

/turf/open/floor/plating/vampcanal/Initialize(mapload)
	..()
	icon_state = "canal[rand(1, 3)]"

/turf/open/floor/plating/vampcanalplating
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "canal_plating1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampcanalplating/Enter(atom/movable/mover, atom/oldloc)
	. = ..()
	if(istype(mover, /mob/living/carbon/human))
		var/mob/living/L = mover
		if(L.client)
			if(prob(10))
				new /mob/living/simple_animal/pet/rat(oldloc)

/turf/open/floor/plating/vampcanal/Initialize(mapload)
	..()
	icon_state = "canal_plating[rand(1, 4)]"

/turf/closed/indestructible/elevatorshaft
	name = "elevator shaft"
	desc = "Floors, floors, floors..."
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "black"

/turf/open/floor/plating/bacotell
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "bacotell"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/gummaguts
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "gummaguts"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY


/turf/open/floor/ship_floor
	name = "metal floor"
	desc = "A sturdy metal floor, commonly found on ships."
	icon = 'code/modules/wod13/ship/smooth_floor.dmi'
	icon_state = "floor-255"
	base_icon_state = "floor-255"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET)
	canSmoothWith = list(SMOOTH_GROUP_CARPET)
	flags_1 = NONE
	bullet_bounce_sound = null

/turf/open/floor/plating/ship
	name = "metal floor"
	desc = "A sturdy metal floor, commonly found on ships."
	icon = 'code/modules/wod13/ship/floor.dmi'
	icon_state = "metal_floor_1"
	base_icon_state = "metal_floor_1"

/turf/open/floor/plating/ship/alt
	icon_state = "metal_floor_2"
	base_icon_state = "metal_floor_2"

/turf/open/floor/plating/ship/metal
	icon_state = "metal_floor_3"
	base_icon_state = "metal_floor_3"

/turf/open/floor/plating/ship/lines
	icon_state = "floor_certa"
	base_icon_state = "floor_certa"

/turf/open/floor/plating/ship/dot
	icon_state = "floor_dots"
	base_icon_state = "floor_dots"

/turf/open/floor/plating/ship/empty
	icon_state = "star-floor"
	base_icon_state = " star-floor"

