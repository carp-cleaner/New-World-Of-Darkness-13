GLOBAL_LIST_INIT(avatar_banned_verbs, list(
	/mob/dead/observer/verb/follow,
	/mob/dead/observer/verb/jumptomob,
	/mob/dead/observer/verb/toggle_ghostsee,
	/mob/dead/observer/verb/toggle_darkness,
	/mob/dead/observer/verb/view_manifest,
	/mob/dead/observer/verb/toggle_data_huds,
	/mob/dead/observer/verb/observe,
	/mob/dead/observer/verb/register_pai_candidate,
	/mob/dead/observer/verb/stay_dead,
	/mob/dead/observer/proc/dead_tele,
	/mob/dead/observer/proc/open_spawners_menu
))

/// Выход в атсрал 5-ая точка ауспекс || For 5-th dot auspex
/mob/dead/observer/avatar
	invisibility = INVISIBILITY_LEVEL_OBFUSCATE+5
	see_invisible = SEE_INVISIBLE_LEVEL_OBFUSCATE+5
	can_reenter_corpse = TRUE
	hud_type = /datum/hud/auspex_avatar
	movement_delay = 0
	movement_type = FLYING | GROUND | PHASING

	var/mob_biotype = MOB_SPIRIT

/mob/dead/observer/avatar/Initialize(mapload)
	. = ..()
	set_invisibility(INVISIBILITY_LEVEL_OBFUSCATE+5)
	add_to_avatar_list()

	remove_verb(src, GLOB.avatar_banned_verbs)

	sight = NONE
	movement_type = FLYING | GROUND | PHASING

/mob/dead/observer/avatar/Destroy()
	remove_from_avatar_list()

	return ..()

/mob/dead/observer/avatar/Move(NewLoc, direct, glide_size_override = 32)
	dir = get_dir(loc, NewLoc)
	for(var/mob/living/L in NewLoc)
		if(L)
			if(L.a_intent == INTENT_HARM && L.lying_angle == 0 && L.dir != dir)
				return
			else
				to_chat(L, "<span class='warning'>You feel cold air rushing through you.</span>")

	var/obj/transfer_point_vamp/V = locate() in NewLoc
	if(V)
		V.Bumped(src)
	..()

/mob/dead/observer/avatar/update_psyche()
	return

/mob/dead/observer/avatar/damage_corpus()
	return

/mob/dead/observer/avatar/reenter_corpse()
	if(!client)
		return FALSE
	if(!mind || QDELETED(mind.current))
		to_chat(src, span_warning("You have no body."))
		return FALSE
	if(!can_reenter_corpse)
		to_chat(src, span_warning("You cannot re-enter your body."))
		return FALSE

	var/mob/living/carbon/human/original_body = mind.current
	var/turf/current_turf = get_turf(src)
	var/turf/body_turf = get_turf(original_body)

	if(isnull(body_turf) || isnull(current_turf))
		return FALSE
	if(!(body_turf == current_turf))
		to_chat(src, span_warning("Your body is not here. It is located at coordinates: [body_turf.x], [body_turf.y], [body_turf.z]."))
		to_chat(src, span_warning("Your current coordinates are: [current_turf.x], [current_turf.y], [current_turf.z]."))
		return FALSE
	if(mind.current.key && mind.current.key[1] != "@")	//makes sure we don't accidentally kick any clients
		to_chat(usr, span_warning("Another consciousness is in your body...It is resisting you."))
		return FALSE

	client.view_size.setDefault(getScreenSize(client.prefs.widescreenpref))//Let's reset so people can't become allseeing gods
	SStgui.on_transfer(src, mind.current)
	mind.current.key = key
	mind.current.client.init_verbs()
	original_body.soul_state = SOUL_PRESENT

	return TRUE

/mob/dead/observer/avatar/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced)
	return

/mob/dead/observer/avatar/say_dead(message)
	return

// Auspex Avatars can't manually orbit people.
/mob/dead/observer/avatar/ManualFollow(atom/movable/target)
	return

/mob/dead/observer/proc/showing()
	var/mob_in = mind.current
	var/mob/living/carbon/C
	if(iscarbon(mob_in))
		C = mob_in
	if(invisibility == 0)
		invisibility = INVISIBILITY_OBSERVER
		alpha = 180
	else
		invisibility = 0
		alpha = 100
		if(C.MyPath)
			C.MyPath.willpower -= 1
		addtimer(CALLBACK(src, PROC_REF(showing)), 10 SECONDS)



///////////// HUMAN PROCS ////////////

/mob/proc/enter_avatar()
	RETURN_TYPE(/mob/dead/observer/avatar)

//	var/mob/living/carbon/human/auspex_avatar = new(src)
	var/mob/dead/observer/avatar/auspex_avatar = new(src)


	auspex_avatar.key = key
	auspex_avatar.client.init_verbs()
	auspex_avatar.client = src.client


	SStgui.on_transfer(src, auspex_avatar)

	auspex_avatar.icon = src.icon
	auspex_avatar.overlays = src.overlays

	auspex_avatar.client.init_verbs()
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTEARS
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTWHISPER
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTSIGHT
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTRADIO
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTPDA
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTLAWS
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_LOGIN_LOGOUT
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_DEAD

	auspex_avatar.Beam(BeamTarget = src, icon_state = "medbeam", beam_type= /obj/effect/ebeam/invisible)
	/*
	auspex_avatar.appearance = appearance
	auspex_avatar.key = key
	auspex_avatar.client = src.client
	auspex_avatar.client.init_verbs()
	auspex_avatar.holder = src
	auspex_avatar.real_name = real_name
	auspex_avatar.name = real_name
	auspex_avatar.mind = mind
	auspex_avatar.client_mobs_in_contents = client_mobs_in_contents
	auspex_avatar.Login()
	auspex_avatar.alpha = 180
	auspex_avatar.Beam(BeamTarget = src, icon_state = "medbeam", beam_type= /obj/effect/ebeam/invisible)
	var/datum/action/reenterauspex/R = new
	R.Grant(auspex_avatar)
*/
//	return auspex_avatar


/*
/mob/auspex
	name = "Auspex Eye"
	real_name = "Auspex Eye"
	desc = ""
	icon = 'icons/mob/cameramob.dmi'
	icon_state = "marker"
	mouse_opacity = MOUSE_OPACITY_ICON
//	move_on_shuttle = FALSE
	see_in_dark = 8
	invisibility = INVISIBILITY_LEVEL_OBFUSCATE+5
	see_invisible = SEE_INVISIBLE_LEVEL_OBFUSCATE+5
	layer = MOB_LAYER
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	sight = SEE_SELF|SEE_THRU
	movement_type = GROUND|PHASING|FLYING
	initial_language_holder = /datum/language_holder/universal

	var/mob/living/holder

/mob/auspex/Initialize(mapload)
	. = ..()
	add_to_avatar_list()

/mob/auspex/Destroy()
	remove_from_avatar_list()

	return ..()

/mob/auspex/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	return holder.say(message)

/mob/auspex/Move(NewLoc, Dir = 0)
	. = ..()

/mob/auspex/forceMove(atom/destination)
	dir = get_dir(get_turf(src), destination)
	loc = destination

/mob/auspex/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	. = ..()
	var/atom/movable/to_follow = speaker
	if(radio_freq)
		var/atom/movable/virtualspeaker/V = speaker
		to_follow = V.source
	var/link
	link = FOLLOW_LINK(src, to_follow)
	// Create map text prior to modifying message for goonchat
	if (client?.prefs.chat_on_map && (client.prefs.see_chat_non_mob || ismob(speaker)))
		create_chat_message(speaker, message_language, raw_message, spans)
	// Recompose the message, because it's scrambled by default
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods)
	to_chat(src, "[link] [message]")


/datum/action/reenterauspex
	name = "Re-Enter Body"
	button_icon_state = "ghost"

/datum/action/reenterauspex/Trigger()
	if(isauspexavatar(usr))
		var/mob/auspex/A = usr
		SStgui.on_transfer(A, A.holder)
		A.holder.key = A.key
		A.holder.client = A.client
		A.holder.client.init_verbs()
		qdel(A)

	*/

