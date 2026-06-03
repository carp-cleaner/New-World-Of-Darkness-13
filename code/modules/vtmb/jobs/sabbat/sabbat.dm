/datum/job/vamp/sabbat_priest
	title = "Sabbat Priest"
	department_head = list("Caine")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Dark Father"
	selection_color = "#6c0404"

	outfit = /datum/outfit/job/sabbat_priest

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_SABBAT_PRIEST
	exp_type_department = EXP_TYPE_SABBAT

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Brujah", "Nosferatu", "Gangrel", "City Gangrel", "Toreador", "Malkavian", "Ventrue", "Banu Haqim", "Banu Haqim Sorcerer", "Banu Haqim Vizier", "Followers of Set", "Tzimisce", "Lasombra", "Kiasyd", "Caitiff", "Cappadocian", "Salubri Warrior")

	v_duty = "Gehenna is nigh. Secure this city for the Army of Caine through diplomacy or violence."
	minimal_masquerade = 0
	max_generation = 9

/datum/outfit/job/sabbat_priest
	name = "Priest"
	jobtype = /datum/job/vamp/sabbat_priest

	uniform = /obj/item/clothing/under/vampire/baali
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/sabbat
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/sabbat_priest/pre_equip(mob/living/carbon/human/H)
	..()
	H.add_to_sect("Sabbat")
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/baali/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/sabbat_priest
	name = "Priest"

/////////////////////////////////////////////////////////////////////////////

/datum/job/vamp/sabbat_ductus
	title = "Ductus"
	department_head = list("Caine")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Priest and Dark Father"
	selection_color = "#6c0404"

	outfit = /datum/outfit/job/sabbat_ductus

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_SABBAT_DUCTUS
	exp_type_department = EXP_TYPE_SABBAT

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Brujah", "Nosferatu", "Gangrel", "City Gangrel", "Toreador", "Malkavian", "Ventrue", "Banu Haqim", "Banu Haqim Sorcerer", "Banu Haqim Vizier", "Followers of Set", "Tzimisce", "Lasombra", "Kiasyd", "Caitiff", "Cappadocian", "Salubri Warrior")

	v_duty = "You are entrusted by you priest to lead the pack forward to victory, do not fail him."
	minimal_masquerade = 0
	max_generation = 9

/datum/outfit/job/sabbat_ductus
	name = "Ductus"
	jobtype = /datum/job/vamp/sabbat_ductus

	uniform = /obj/item/clothing/under/vampire/punk
	shoes = /obj/item/clothing/shoes/vampire/sneakers
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/sabbat
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/sabbat_ductus/pre_equip(mob/living/carbon/human/H)
	..()
	H.add_to_sect("Sabbat")

/obj/effect/landmark/start/sabbat_ductus
	name = "Ductus"

/////////////////////////////////////////////////////////////////////////////

/datum/job/vamp/sabbat
	title = "Pack Member"
	department_head = list("Caine")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "Priest and Dark Father"
	selection_color = "#6c0404"

	outfit = /datum/outfit/job/sabbat

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_SABBAT
	exp_type_department = EXP_TYPE_SABBAT

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Brujah", "Nosferatu", "Gangrel", "City Gangrel", "Toreador", "Malkavian", "Ventrue", "Banu Haqim", "Banu Haqim Sorcerer", "Banu Haqim Vizier", "Followers of Set", "Tzimisce", "Lasombra", "Kiasyd", "Caitiff", "Cappadocian", "Salubri Warrior")

	v_duty = "Your pack infiltrated the city to secure it for the Sabbat."
	experience_addition = 0
	minimal_masquerade = 0
	max_generation = 10

/datum/outfit/job/sabbat
	name = "Pack Member"
	jobtype = /datum/job/vamp/sabbat

	uniform = /obj/item/clothing/under/vampire/bandit
	shoes = /obj/item/clothing/shoes/vampire/sneakers
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/sabbat
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/sabbat/pre_equip(mob/living/carbon/human/H)
	..()
	H.add_to_sect("Sabbat")

/obj/effect/landmark/start/sabbat
	name = "Pack Member"

/////////////////////////////////////////////////////////////////////////////

/datum/outfit/job/sabbatist
	name = "Sabbatist"
//	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/sabbat
//	suit = /obj/item/clothing/suit/vampire/trench
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/vampire_stake=3, /obj/item/gun/ballistic/vampire/revolver=1, /obj/item/melee/vampirearms/knife=1, /obj/item/vamp/keys/hack=1, /obj/item/melee/vampirearms/katana/kosa=1)

/datum/outfit/job/sabbatist/pre_equip(mob/living/carbon/human/H)
	..()
	H.add_to_sect("Sabbat")
//	H.vampire_faction = "Sabbat"
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/vampire
		if(H.clane)
			if(H.clane.male_clothes)
				uniform = H.clane.male_clothes
	else
		shoes = /obj/item/clothing/shoes/vampire/heels
		if(H.clane)
			if(H.clane.female_clothes)
				uniform = H.clane.female_clothes

/datum/outfit/job/sabbatist/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/sabbatist)
	GLOB.sabbatites += H

	var/my_name = "Tyler"
	if(H.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	H.fully_replace_character_name(null,"[my_name] [my_surname]")
//Commented out code for future sabbat character setup
/*
	H.generation = 13
	H.clane = null

	H.maxHealth = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique+13-H.generation))
	H.health = round((initial(H.health)-initial(H.health)/4)+(initial(H.health)/4)*(H.physique+13-H.generation))
	REMOVE_TRAIT(H, TRAIT_THAUMATURGY_KNOWLEDGE, DISCIPLINE_TRAIT)
	QDEL_NULL(H.clane)
	var/obj/item/organ/eyes/NV = new()
	NV.Insert(H, TRUE, FALSE)
	add_verb(H, /datum/job/sabbatist/verb/setup_character)
*/

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)
	var/list/loadouts = list("Doctor", "Supply Technician", "Street Janitor", "Graveyard Keeper", "Taxi Driver", "Police Officer", "Citizen")
	spawn()
		var/loadout_type = input(H, "Choose your Mask:", "Loadout") as anything in loadouts
		switch(loadout_type)
			if("Doctor")
				H.equipOutfit(/datum/outfit/job/vdoctor)
			if("Supply Technician")
				H.equipOutfit(/datum/outfit/job/supply)
			if("Street Janitor")
				H.equipOutfit(/datum/outfit/job/vjanitor)
			if("Graveyard Keeper")
				H.equipOutfit(/datum/outfit/job/graveyard)
			if("Taxi Driver")
				H.equipOutfit(/datum/outfit/job/taxi)
				new /obj/vampire_car/taxi(get_turf(H))
			if("Police Officer")
				H.equipOutfit(/datum/outfit/job/police_officer)
			if("Chantry Archivist")
				H.equipOutfit(/datum/outfit/job/archivist)
			if("Citizen")
				H.equipOutfit(/datum/outfit/job/citizen)

//Commented out code for future sabbat character setup

/obj/effect/landmark/start/sabbatist
	name = "Sabbatist"
//	delete_after_roundstart = FALSE
