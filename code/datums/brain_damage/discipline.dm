/datum/brain_trauma/magic/presence_awe
	name = "Presence Awe"
	desc = ""
	scan_desc = ""
	gain_text = ""
	lose_text = ""
	resilience = TRAUMA_RESILIENCE_ABSOLUTE
	random_gain = FALSE
	var/trauma_caster

/datum/brain_trauma/magic/presence_awe/New(mob_caster)
	if(!mob_caster)
		qdel(src)
	trauma_caster = mob_caster
	..()

/datum/brain_trauma/magic/presence_awe/handle_hearing(datum/source, list/hearing_args)
	if(trauma_caster == hearing_args[HEARING_SPEAKER])
		var/message = hearing_args[HEARING_RAW_MESSAGE]
		hearing_args[HEARING_RAW_MESSAGE] = span_userlove(message)
