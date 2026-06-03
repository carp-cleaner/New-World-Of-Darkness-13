/mob/living/carbon
	var/datum/morality_path/MyPath

/datum/morality_path
	var/mob/living/carbon/human/owner
	var/name = "Path"
	var/desc = "This is a default path for everyone."
	var/dot = 5
	var/willpower = 5
	var/consience = 1
	var/selfcontrol = 1
	var/courage = 1

	var/list/ready_events = list()

/*
	var/list/ready_events = list("slur" = 0, "attackfirst" = 0, "steal" = 0, "robbery" = 0, "drugdealing" = 0, "organtrade" = 0, "drying" = 0, "kill" = 0,
	"massmurder" = 0, "diablerie" = 0, "cpr" = 0, "shockpaddles" = 0, "donate" = 0, "dance" = 0, "syrgery", "examination" = 0, "animaldrink" = 0, "ratdrink" = 0, "packetdrink" = 0,
	"baddrink" = 0, "gooddrink" = 0, "firstfeed" = 0, "suncoming" = 0, "rotshreck" = 0, "bloodhunger" = 0, "pretorpor" = 0, "jumpfail" = 0, "jumpsuccess" = 0,
	"deadexamine" = 0, "onfire" = 0, "highspeed" = 0, "attacked" = 0, "attackedfail" = 0, "gettingdrunk" = 0, "talkenough" = 0, "cleanenough" = 0, "gettinghigh" = 0,
	"corpseitems" = 0, "friendmeet" = 0, "lovermeet" = 0)
	*/

	var/list/bad_events = list("attackfirst", "steal", "robbery", "drugdealing",
	"organtrade", "drying", "kill", "massmurder", "diablerie")
	var/murder_victms = 0	//So when it hits 5 it's confirmed mass murder


/datum/morality_path/proc/trigger_morality(trig_event)
	if(bad_events.Find(trig_event))
		for(var/mob/living/carbon/human/H in viewers(7, owner))
			if(H != owner && H.mind?.dharma)
				if("judgement" in H.mind.dharma.tenets)
					to_chat(H, "<span class='warning'>[owner] is doing something bad, I need to punish them!")
					H.mind.dharma.judgement |= owner.real_name

/*
	if(ready_events[trig_event] == 1)
		return
	ready_events[trig_event] = 1
*/

/datum/morality_path/proc/adjust(point)
	if(!iskindred(owner))
		return

	if(point == 0)
		return

	if(!GLOB.canon_event)
		return

	var/special_role_name
	if(owner.mind)
		if(owner.mind.special_role)
			var/datum/antagonist/A = owner.mind.special_role
			special_role_name = A.name

	if(is_special_character(owner) && special_role_name != "Ambitious")
		return

	if(point < 1 && dot > 0)
		dot = dot+point
		SEND_SOUND(owner, sound('code/modules/wod13/sounds/humanity_loss.ogg', 0, 0, 75))
		to_chat(owner, "<span class='userdanger'><b>[name] decreased!</b></span>")
	if(point > 1 && dot < 10)
		dot = dot+point
		willpower = willpower+1
		SEND_SOUND(owner, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
		to_chat(owner, "<span class='userhelp'><b>[name] increased!</b></span>")

	willpower = min(dot, willpower)
	owner.humanity = dot
	var/datum/preferences/P = GLOB.preferences_datums[ckey(owner.key)]
	if(P)
		if(P.humanity != owner.humanity)
			P.humanity = owner.humanity
			P.save_preferences()
			P.save_character()
		if(!owner.antifrenzy)
			if(P.humanity < 1)
				owner.enter_frenzymod()
				reset_shit(owner)
				to_chat(owner, "<span class='userdanger'>You have lost control of the void within you, and it has taken your body. Be more humane next time.</span>")
				owner.ghostize(FALSE)
				P.reason_of_death = "Lost control to the Beast ([time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")])."
//	switch(trig_event)
//		if("trigger_default")
//			to_chat(owner, "[icon2html('icons/beast.png', owner)] <span class='secradio'><b>BEAST</b></span><span class='discosay'> — Доверься своему телу. Запугивай людей.</span>")

/*
/datum/morality_path/proc/call_path(vitrues, dot)
	switch(vitrues)
		if("Beast")
*/

/*
/datum/morality_path/Initialize()
	var/list/initialized_virtues = list()
	for(var/i in virtues)
		var/datum/virtue/V = new i
		V.path = src
		initialized_virtues += V
	virtues = initialized_virtues

/datum/virtue
	var/datum/morality_path/path
	var/name = "VIRTUE"
	var/icon = 'icons/beast.png'
	var/dot = 1
	var/span = "<span class='secradio'>"
	var/list/ready_events = list()

/datum/virtue/proc/trigger(trigger_event)
	if(trigger_event in ready_events)
		return
	ready_events += trigger_event
	switch(trigger_event)
		if("trigger_default")
			to_chat(path.owner, "[icon2html(icon, path.owner)] [span]<b>[name]</b></span><span class='discosay'> — Доверься своему телу. Запугивай людей.</span>")

/datum/virtue/beast
	name = "ЗВЕРЬ"
	icon = 'icons/beast.png'
	dot = 5
	span = "<span class='secradio'>"

/datum/virtue/consience
	name = "СОЗНАТЕЛЬНОСТЬ"
	icon = 'icons/consience.png'
//	dot = 1
	span = "<span class='comradio'>"


/datum/virtue/selfcontrol
	name = "САМОКОНТРОЛЬ"
	icon = 'icons/self-control.png'
//	dot = 1
	span = "<span class='medradio'>"

/datum/virtue/instinctes
	name = "ИНСТИНКТЫ"
	icon = 'icons/self-control.png'

/datum/virtue/selfcontrol
	name = "УБЕЖДЁННОСТЬ"
	icon = 'icons/self-control.png'

/datum/virtue/courage
	name = "СМЕЛОСТЬ"
	icon = 'icons/courage.png'
//	dot = 1
	span = "<span class='sciradio'>"

/datum/morality_path/road
	name = "Дорога"
	desc = "Средневековые пути"

/datum/morality_path/humanity
	name = "Человечность"
	desc = "Она показывает, сколько человеческого осталось от персонажа после Объятий. Именно Человечность не дает вампиру стать кровожадным монстром, который думает только о своем пропитании."
//	dot = 5
//	willpower = 5
	virtues = list(/datum/virtue/beast, /datum/virtue/consience, /datum/virtue/selfcontrol, /datum/virtue/courage)


//BEAST
//SELF-CONTROL "hunger", "bloodhunger", "gettingdrunk"
//COURAGE "crinos", "screamelysium"
//CONSCIENCE "corpseitems", "gettinghigh"

//	var/analyze_virtue = /datum/virtue
//	var/control_virtue = /datum/virtue
//	var/courage_virtue = /datum/virtue
//	var/beast_virtue = /datum/virtue
//	var/list/virtues = list(/datum/virtue)

*/
