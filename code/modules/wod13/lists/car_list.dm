/obj/vampire_car/retro
	icon_state = "1"
	max_passengers = 1
	dir = WEST

/obj/vampire_car/retro/rand
	icon_state = "3"

/obj/vampire_car/retro/rand/Initialize(mapload)
	icon_state = "[pick(1, 3, 5)]"
	if(access == "none")
		access = "npc[rand(1, 20)]"
	..()

/obj/vampire_car/rand
	icon_state = "4"
	dir = WEST

/obj/vampire_car/rand/Initialize(mapload)
	icon_state = "[pick(2, 4, 6)]"
	if(access == "none")
		access = "npc[rand(1, 20)]"
	..()

/obj/vampire_car/rand/camarilla
	access = "camarilla"
	icon_state = "6"

/obj/vampire_car/retro/rand/camarilla
	access = "camarilla"
	icon_state = "5"

/obj/vampire_car/rand/anarch
	access = "anarch"
	icon_state = "6"

/obj/vampire_car/retro/rand/anarch
	access = "anarch"
	icon_state = "5"

/obj/vampire_car/rand/clinic
	access = "clinic"
	icon_state = "6"

/obj/vampire_car/retro/rand/clinic
	access = "clinic"
	icon_state = "5"

/obj/vampire_car/police
	icon = 'code/modules/wod13/icons_newvechle/car_police.dmi'
	icon_state = "police"
	max_passengers = 4
	dir = WEST
	beep_sound = 'code/modules/wod13/sounds/migalka.ogg'
	access = "police"
	lighticon = "lights"
	baggage_limit = 45
	baggage_max = WEIGHT_CLASS_BULKY
	var/color_blue = FALSE
	var/last_color_change = 0
	var/migalka = FALSE

/obj/vampire_car/police/handle_caring()
	if(migalka)
		if(last_color_change+10 <= world.time)
			last_color_change = world.time
			if(color_blue)
				color_blue = FALSE
				set_light(0)
				set_light(4, 6, "#ff0000")
			else
				color_blue = TRUE
				set_light(0)
				set_light(4, 6, "#0000ff")
	else
		if(last_color_change+10 <= world.time)
			last_color_change = world.time
			set_light(0)
	..()

/obj/vampire_car/police/old
	icon = 'code/modules/wod13/cars.dmi'
	icon_state = "police"

/obj/vampire_car/taxi
	icon_state = "taxi"
	max_passengers = 3
	dir = WEST
	access = "taxi"
	baggage_limit = 40
	baggage_max = WEIGHT_CLASS_BULKY

//////// TRUCK /////////////////

/obj/vampire_car/track
	icon_state = "track"
	max_passengers = 6
	lighticon = "lights2"
	dir = WEST
	access = "none"
	baggage_limit = 100
	baggage_max = WEIGHT_CLASS_BULKY
	delivery_capacity = 15
	component_type = /datum/component/storage/concrete/vtm/car/track

/obj/vampire_car/track/Initialize(mapload)
	if(access == "none")
		access = "npc[rand(1, 20)]"
	..()

/obj/vampire_car/track/volkswagen
	icon_state = "volkswagen"
	lighticon = "lights3"
	baggage_limit = 60

/obj/vampire_car/track/volkswagen/buhanka
	icon_state = "buhanka"
	lighticon = "lights3"
	baggage_limit = 60

/obj/vampire_car/track/ambulance
	icon = 'code/modules/wod13/icons_newvechle/car_ambulance.dmi'
	icon_state = "ambulance"
	lighticon = "lights2"
	access = "clinic"
	baggage_limit = 60
	delivery_capacity = 5
	var/migalka = FALSE
	var/last_color_change = 0

/obj/vampire_car/track/ambulance/handle_caring()
	if(migalka)
		if(last_color_change+10 <= world.time)
			last_color_change = world.time
			set_light(0)
			set_light(4, 6, "#ff0000")
	else
		if(last_color_change+10 <= world.time)
			last_color_change = world.time
			set_light(0)
	..()

/////// LIMUSINES //////////////////

/obj/vampire_car/limuzini_bombini
	icon_state = "limo"
	lighticon = "lights5"
	access = "camarilla"
	max_passengers = 6


/obj/vampire_car/limuzini_bombini/giovanie
	icon_state = "giolimo"
	lighticon = "lights4"
	access = "giovanni"


///// NEW ////////////////////////

/obj/vampire_car/chevrolet
	name = "chevrolet"
	icon = 'code/modules/wod13/icons_newvechle/car_chevrolet.dmi'
	icon_state = "chevrolet_black"
	desc = "Blast from the past"
	car_type = "chevrolet"
	lighticon = "chevrolet_lights"
	max_passengers = 4
	dir = WEST
	access = "church"
	baggage_limit = 45
	baggage_max = WEIGHT_CLASS_BULKY


////////// SPORTCAR //////////////

/obj/vampire_car/sportcar
	name = "sportcar"
	icon = 'code/modules/wod13/icons_newvechle/car_supercar.dmi'
	icon_state = "supercar_neon"
	desc = "Some kind of modern and fast car"
	car_type = "sportcar"

//////// MINIVAN ////////////////////

/obj/vampire_car/minivan
	icon = 'code/modules/wod13/icons_newvechle/car_minivan.dmi'
	icon_state = "minivan_white"
	max_passengers = 5
	car_type = "minivan"

/obj/vampire_car/minivan/police
	icon_state = "police"
	maxhealth = 300
	desc = "There's even a Mr Dog bed here!"
	access = "police"

/obj/vampire_car/minivan/yellow
	icon_state = "minivan_yellow"

/obj/vampire_car/blue
	icon_state = "minivan_blue"

/////// VAN //////////////////////
/obj/vampire_car/van
	icon = 'code/modules/wod13/icons_newvechle/car_van.dmi'
	icon_state = "van_white"
	max_passengers = 4
	car_type = "van"

/obj/vampire_car/van/swat
	icon_state = "van_swat"
	maxhealth = 400
	desc = "A heavily armored van used by special police units."
	max_passengers = 6
	access = "swat"

/obj/vampire_car/van/black
	icon_state = "van_black"

/obj/vampire_car/van/brown
	icon_state = "van_brown"

