/datum/antagonist/sabbatist
	name = "Sabbatist"
	roundend_category = "sabbattites"
	antagpanel_category = "Sabbat"
	job_rank = ROLE_REV
	antag_moodlet = /datum/mood_event/revolution
	antag_hud_type = ANTAG_HUD_REV
	antag_hud_name = "rev"
	var/datum/team/sabbat_cainites/team

/datum/antagonist/sabbatist/on_gain()
	add_antag_hud(ANTAG_HUD_REV, "rev", owner.current)
	owner.special_role = src
	var/list/objective_list = list(
		/datum/objective/sabbat,
		/datum/objective/sabbat/convert,
		/datum/objective/survive,
	) //Warning! We have additional objective on /datum/team!
	for(var/O in objective_list)
		var/datum/objective/custom_objective = new O()
		custom_objective.owner = owner
		objectives += custom_objective

	var/datum/team/sabbat_cainites/team = locate(/datum/team/sabbat_cainites) in GLOB.antagonist_teams
	if(!team)
		team = new()
	team.add_member(owner)

	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/evil_start.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	return ..()

/datum/antagonist/sabbatist/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You are no longer the Sabbat Shovelhead!</span>")
	owner.special_role = null
	team?.UnregisterSignal(owner.current, COMSIG_KILL)

/datum/antagonist/sabbatist/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are the Sabbat Shovelhead.</span>")
	owner.announce_objectives()

/datum/antagonist/sabbatist/on_body_transfer(mob/living/old_body, mob/living/new_body)
	. = ..()
	if(team)
		team.UnregisterSignal(old_body, COMSIG_KILL)
		team.RegisterSignal(new_body, COMSIG_KILL, TYPE_PROC_REF(/datum/team/sabbat_cainites, count_kills))

//TEAM
/datum/team/sabbat_cainites
	name = "Cainites" //I geniuly dont know how to call them cause just "sabbat" is taken by the fucking revs. Why? Not to me

/datum/team/sabbat_cainites/New(starting_members)
	. = ..()
	var/datum/objective/sabbat/mass_murder/obj = new()
	objectives += obj
	obj.team = src

/datum/team/sabbat_cainites/add_member(datum/mind/new_member)
	. = ..()
	var/datum/antagonist/sabbatist/A = new_member.has_antag_datum(/datum/antagonist/sabbatist)
	if(!A) return //Say NO to admeme!
	A.team = src
	RegisterSignal(new_member.current, COMSIG_KILL, PROC_REF(count_kills))

	var/need_kills = 4 * length(members)
	for(var/datum/objective/sabbat/mass_murder/obj in objectives) //Do we have 1 objective? Good. Did admeme happen? No bugs
		obj.needed = need_kills
		obj.update_explanation_text()

		A.objectives += obj

	for(var/datum/mind/M in members)
		to_chat(M.current, "<span class='alertsyndie'>Now we need to kill [need_kills] mortals!</span>")

/datum/team/sabbat_cainites/proc/count_kills()
	for(var/datum/objective/sabbat/mass_murder/obj in objectives)
		obj.kills++
		if(obj.needed < obj.kills)
			return
		for(var/datum/mind/M in members)
			to_chat(M.current, "<span class='notice'> We [obj.kills == obj.needed ? "achieved" : "need to kill [obj.needed - obj.kills] more to achieve"] our goals in blood.</span>")
