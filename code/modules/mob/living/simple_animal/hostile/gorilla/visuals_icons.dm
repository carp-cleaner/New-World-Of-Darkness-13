/mob/living/simple_animal/hostile/gorilla/proc/apply_overlay(cache_index)
	. = gorilla_overlays[cache_index]
	if(.)
		add_overlay(.)

/mob/living/simple_animal/hostile/gorilla/proc/remove_overlay(cache_index)
	var/I = gorilla_overlays[cache_index]
	if(I)
		cut_overlay(I)
		gorilla_overlays[cache_index] = null
