SUBSYSTEM_DEF(masquerade)
	name = "Masquerade"
	init_order = INIT_ORDER_DEFAULT
	wait = 1200
	priority = FIRE_PRIORITY_VERYLOW

	var/total_level = 1000
	var/dead_level = 0
	var/last_level = "stable"
	var/manual_adjustment = 0
	var/can_raise = TRUE

/datum/controller/subsystem/masquerade/proc/get_description()
	switch(total_level)
		if(0 to 250)
			return "MASSIVE BREACH"
		if(251 to 500)
			return "MODERATE VIOLATION"
		if(501 to 750)
			return "SUSPICIOUS"
		else
			return "STABLE"

/datum/controller/subsystem/masquerade/fire()
	var/masquerade_violators = 0
	var/sabbat = 0
	if(length(GLOB.masquerade_breakers_list))
		for(var/mob/living/L in GLOB.masquerade_breakers_list)
			if(L)
				if(!L.was_spoted)
					masquerade_violators += (5-L.masquerade)*40
					L.was_spoted = 1
	if(length(GLOB.sabbatites))
		sabbat = length(GLOB.sabbatites)*100


	if(can_raise)
		total_level = max(0, min(1000, 1000 + dead_level + manual_adjustment - masquerade_violators - sabbat))
	else
		total_level = max(0, min(total_level, total_level + manual_adjustment))


	var/shit_happens = "stable"
	switch(total_level)
		if(0 to 250)
			shit_happens = "breach"
		if(251 to 500)
			shit_happens = "moderate"
		if(501 to 750)
			shit_happens = "slightly"
		else
			shit_happens = "stable"

	if(last_level != shit_happens)
		last_level = shit_happens
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H)
				if(iskindred(H) || isghoul(H))
					switch(last_level)
						if("stable")
							to_chat(H, "The night becomes clear. Nothing can threaten the Masquerade.")
						if("slightly")
							to_chat(H, "Something is going wrong here...")
						if("moderate")
							to_chat(H, "People start noticing...")
							SShumannpcpool.npclost()
						if("breach")
							to_chat(H, "The Masquerade is about to fall...")
							SShumannpcpool.npclost()
		if(last_level == "moderate")
			SEND_SOUND(world, sound('code/modules/wod13/sounds/curfew.ogg', 0, 0, 100))
			to_chat(world, "<span class='userdanger'><b>EMERGENCY ALERT – CITY OF SAN FRANCISCO</b></span>")
			to_chat(world, "<b>Due to a sharp rise in violence and reports of unknown threats, a citywide curfew is now in effect from 9:00 PM until 6:00 AM daily until further notice. All residents are required to remain indoors during curfew hours. Essential travel only will be permitted. Public safety agencies are actively investigating the situation and working to restore security. Please remain vigilant, avoid large gatherings, and report suspicious activity to 911 immediately. Updates will be provided through official city channels, local news, and emergency alerts.</b>")
			can_raise = FALSE
		if(last_level == "breach")
			SEND_SOUND(world, sound('code/modules/wod13/sounds/curfew2.ogg', 0, 0, 100))
			to_chat(world, "<span class='userdanger'><b>EMERGENCY ALERT – CITY OF SAN FRANCISCO</b></span>")
			to_chat(world, "<b>Due to extreme violence and unknown widespread threats, the City of San Francisco is now under a total lockdown until further notice. All residents must remain indoors at all times. Travel, gatherings, and outdoor activity are strictly prohibited. Public safety agencies are fully mobilized to contain the danger. Remain alert, secure your home, and report urgent threats to 911 only. Updates will be provided through official city channels, emergency alerts, and local news.</b>")
			can_raise = FALSE

//	SShumannpcpool.npclost()
	if(total_level <= 250)
		for(var/mob/living/carbon/H in GLOB.player_list)
			if(H)
				if(iskindred(H) || iscathayan(H) || isgarou(H) || iscrinos(H))
					if(!H.warrant && !H.ignores_warrant && H.masquerade <= 2)
						H.last_nonraid = world.time
						H.warrant = TRUE
						SEND_SOUND(H, sound('code/modules/wod13/sounds/humanity_loss.ogg', 0, 0, 75))
						to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
//Spotted body -25
//Blood -5 for each
//Masquerade violation -50
//Masquerade reinforcement +25
//Final death +50

/mob/living
	var/was_spoted = 0
