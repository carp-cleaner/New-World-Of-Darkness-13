/*
/mob/living
	var/datum/action/discipline/discipline_ranged

/mob/living/Click()
	if(isliving(usr) && usr != src)
		var/mob/living/L = usr
		if(L.discipline_ranged)
			L.discipline_ranged.active_check = FALSE
			if(L.discipline_ranged.button)
				animate(L.discipline_ranged.button, color = "#ffffff", time = 10, loop = 1)
			if(L.discipline_ranged.discipline.check_activated(src, usr))
				L.discipline_ranged.discipline.activate(src, usr)
			L.discipline_ranged = null
	. = ..()
*/
/mob/living/proc/tremere_gib()
	Stun(5 SECONDS)
	new /obj/effect/temp_visual/tremere(loc, "gib")
	animate(src, pixel_y = 16, color = "#ff0000", time = 50, loop = 1)

	spawn(5 SECONDS)
		if(stat != DEAD)
			death()
		var/list/items = list()
		items |= get_equipped_items(TRUE)
		for(var/obj/item/I in items)
			dropItemToGround(I)
		drop_all_held_items()
		spawn_gibs()
		spawn_gibs()
		spawn_gibs()
		qdel(src)

