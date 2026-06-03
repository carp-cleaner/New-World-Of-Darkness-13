GLOBAL_LIST_EMPTY(npc_spawn_points)
SUBSYSTEM_DEF(humannpcpool)
	name = "Human NPC Pool"
	flags = SS_POST_FIRE_TIMING|SS_NO_INIT|SS_BACKGROUND
	priority = FIRE_PRIORITY_VERYLOW
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 3 SECONDS

	var/list/currentrun = list()
	var/npc_max = 150

/datum/controller/subsystem/humannpcpool/stat_entry(msg)
	var/list/activelist = GLOB.npc_list
	var/list/living_list = GLOB.alive_npc_list
	msg = "NPCS:[length(activelist)] Living: [length(living_list)]"
	return ..()

/datum/controller/subsystem/humannpcpool/fire(resumed = FALSE)

	for(var/mob/spectre/S in GLOB.spectre_list)
		if(S)
			S.handle_haunting()

	if (!resumed)
		var/list/activelist = GLOB.npc_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/living/carbon/human/npc/NPC = currentrun[currentrun.len]
		--currentrun.len

		if (QDELETED(NPC)) // Some issue causes nulls to get into this list some times. This keeps it running, but the bug is still there.
			GLOB.npc_list -= NPC		//HUH??? A BUG? NO WAY
			GLOB.alive_npc_list -= NPC
//			if(QDELETED(NPC))
			npclost()
			log_world("Found a null in npc list!")
//			else
//				log_world("Found a dead NPC in npc list!")
			continue

		//!NPC.route_optimisation()
		if(MC_TICK_CHECK)
			return
		NPC.handle_automated_movement()
		npclost()


/datum/controller/subsystem/humannpcpool/proc/npclost()
	while(length(GLOB.alive_npc_list) < npc_max)
		var/atom/kal = pick(GLOB.npc_spawn_points)
		var/NEPIS = pick(/mob/living/carbon/human/npc/police, /mob/living/carbon/human/npc/bandit, /mob/living/carbon/human/npc/hobo, /mob/living/carbon/human/npc/walkby, /mob/living/carbon/human/npc/business)
		if(prob(3))
			NEPIS = /mob/living/carbon/human/npc/hunter

		if(length(SSbloodhunt.hunted) && !GLOB.camarilla_autoritories)
			if(length(GLOB.camarilla_autoritories) <= 0)
		//		if(prob(10))
				NEPIS = /mob/living/carbon/human/npc/camarilla/ghoul

		if(SSmasquerade.last_level == "moderate")
			NEPIS = pick(/mob/living/carbon/human/npc/police, /mob/living/carbon/human/npc/swat)

		if(SSmasquerade.last_level == "breach")
			NEPIS = pick(/mob/living/carbon/human/npc/police, /mob/living/carbon/human/npc/swat, /mob/living/carbon/human/npc/hunter)
		new NEPIS(get_turf(kal))

SUBSYSTEM_DEF(actionnpcpool)
	name = "Action NPC Pool"
	flags = SS_POST_FIRE_TIMING|SS_NO_INIT|SS_BACKGROUND
	priority = FIRE_PRIORITY_VERYLOW
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 7 SECONDS

	var/list/currentrun = list()

/datum/controller/subsystem/actionnpcpool/stat_entry(msg)
	var/list/activelist = GLOB.npc_list
	var/list/living_list = GLOB.alive_npc_list
	msg = "NPCS:[length(activelist)] Living: [length(living_list)]"
	return ..()

/datum/controller/subsystem/actionnpcpool/fire(resumed = FALSE)

	if (!resumed)
		var/list/activelist = GLOB.npc_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/living/carbon/human/npc/NPC = currentrun[currentrun.len]
		--currentrun.len

		if (QDELETED(NPC)) // Some issue causes nulls to get into this list some times. This keeps it running, but the bug is still there.
			GLOB.npc_list -= NPC		//HUH??? A BUG? NO WAY
			GLOB.alive_npc_list -= NPC
//			if(QDELETED(NPC))
			log_world("Found a null in npc list!")
//			else
//				log_world("Found a dead NPC in npc list!")
			continue

		//!NPC.route_optimisation()
		if(MC_TICK_CHECK)
			return
		NPC.handle_automated_action()
		SShumannpcpool.npclost()
