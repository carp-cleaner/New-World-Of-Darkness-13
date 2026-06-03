/** Creates a thinking indicator over the mob. */
/mob/proc/create_thinking_indicator()
	return

/** Removes the thinking indicator over the mob. */
/mob/proc/remove_thinking_indicator()
	return

/** Creates a typing indicator over the mob. */
/mob/proc/create_typing_indicator()
	return

/** Removes the typing indicator over the mob. */
/mob/proc/remove_typing_indicator()
	return

/** Removes any indicators and marks the mob as not speaking IC. */
/mob/proc/remove_all_indicators()
	return

/mob/set_stat(new_stat)
	. = ..()
	if(.)
		remove_all_indicators()

/mob/Logout()
	remove_all_indicators()
	return ..()

/** Sets the mob as "thinking" - with indicator and the TRAIT_THINKING_IN_CHARACTER trait */
/client/proc/start_thinking()
	/// Special exemptions
	if(isabductor(mob))
		return FALSE
	ADD_TRAIT(mob, TRAIT_THINKING_IN_CHARACTER, CURRENTLY_TYPING_TRAIT)
	mob.create_thinking_indicator()

/** Removes typing/thinking indicators and flags the mob as not thinking */
/client/proc/stop_thinking()
	mob?.remove_all_indicators()

/**
 * Handles the user typing. After a brief period of inactivity,
 * signals the client mob to revert to the "thinking" icon.
 */
/client/proc/start_typing()
	var/mob/client_mob = mob
	client_mob.remove_thinking_indicator()
	if(!HAS_TRAIT(client_mob, TRAIT_THINKING_IN_CHARACTER))
		return FALSE
	client_mob.create_typing_indicator()
	addtimer(CALLBACK(src, PROC_REF(stop_typing)), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/**
 * Callback to remove the typing indicator after a brief period of inactivity.
 * If the user was typing IC, the thinking indicator is shown.
 */
/client/proc/stop_typing()
	if(isnull(mob))
		return FALSE
	var/mob/client_mob = mob
	client_mob.remove_typing_indicator()
	if(!HAS_TRAIT(client_mob, TRAIT_THINKING_IN_CHARACTER))
		return FALSE
	client_mob.create_thinking_indicator()

/** Sets the mob as "thinking" - with indicator and the TRAIT_THINKING_IN_CHARACTER trait */
/datum/tgui_say/proc/start_thinking()
	if(!window_open)
		return FALSE
	return client.start_thinking()

/** Removes typing/thinking indicators and flags the mob as not thinking */
/datum/tgui_say/proc/stop_thinking()
	return client.stop_thinking()

/**
 * Handles the user typing. After a brief period of inactivity,
 * signals the client mob to revert to the "thinking" icon.
 */
/datum/tgui_say/proc/start_typing()
	if(!window_open)
		return FALSE
	return client.start_typing()

/**
 * Remove the typing indicator after a brief period of inactivity or during say events.
 * If the user was typing IC, the thinking indicator is shown.
 */
/datum/tgui_say/proc/stop_typing()
	if(!window_open)
		return FALSE
	client.stop_typing()

/// Overrides for overlay creation
/mob/living/carbon/create_thinking_indicator()
	if(active_thinking_indicator || active_typing_indicator || stat != CONSCIOUS || !HAS_TRAIT(src, TRAIT_THINKING_IN_CHARACTER))
		return FALSE

	active_thinking_indicator = mutable_appearance('icons/mob/talk.dmi', "default0", SAY_LAYER)
	add_overlay(active_thinking_indicator)

/mob/living/carbon/remove_thinking_indicator()
	if(!active_thinking_indicator)
		return FALSE
	cut_overlay(active_thinking_indicator)
	active_thinking_indicator = null

/mob/living/carbon/create_typing_indicator()
	if(active_typing_indicator || active_thinking_indicator || stat != CONSCIOUS || !HAS_TRAIT(src, TRAIT_THINKING_IN_CHARACTER))
		return FALSE

	active_typing_indicator = mutable_appearance('icons/mob/talk.dmi', "default0", SAY_LAYER)
	add_overlay(active_typing_indicator)

/mob/living/carbon/remove_typing_indicator()
	if(!active_typing_indicator)
		return FALSE
	cut_overlay(active_typing_indicator)
	active_typing_indicator = null

/mob/living/carbon/remove_all_indicators()
	REMOVE_TRAIT(src, TRAIT_THINKING_IN_CHARACTER, CURRENTLY_TYPING_TRAIT)
	remove_thinking_indicator()
	remove_typing_indicator()

