/datum/job/vamp/garou/spiral/lead
	title = "Endron Branch Lead"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Endron International")
	faction = "Vampire"

	minimal_renownrank = 3
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Board and Yourself"
	selection_color = "#015334"

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 180
	exp_type_department = EXP_TYPE_SPIRAL

	outfit = /datum/outfit/job/garou/endronlead

	access = list(ACCESS_ROBOTICS, ACCESS_RND, ACCESS_TOXINS, ACCESS_TOXINS_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_TECH_STORAGE, ACCESS_GENETICS, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_RND, ACCESS_TOXINS, ACCESS_TOXINS_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_ENDRONLEAD

	minimal_masquerade = 4
	allowed_species = list("Werewolf", "Human")
	allowed_tribes = list("Black Spiral Dancers")

	my_contact_is_important = TRUE
	known_contacts = list("Endron Employee", "Endron Security Agent", "Endron Chief of Security", "Endron Executive")

	v_duty = "You are the current branch leader for the Endron Oil Refinery, operating out of San Francisco. Your job is to fuel production, keep your clowns in line, and to bring forth the banes that will ultimately allow the Wyrm to prevail over the Weaver."
	experience_addition = 0

/datum/outfit/job/garou/endronlead
	name = "Endron Branch Lead"
	jobtype = /datum/job/vamp/garou/spiral/lead

	ears = /obj/item/p25radio
	id = /obj/item/card/id/vamp/garou/spiral/lead
	uniform =  /obj/item/clothing/under/pentex/pentex_executive_suit
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/endron_lead
	r_pocket = /obj/item/vamp/keys/pentextop
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard/elder=1)

/datum/outfit/job/garou/endronlead/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/pentex/pentex_executiveskirt
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/garou/spiral/lead
	name = "Endron Branch Lead"
	icon_state = "Prince"

///////////////////////////////////////////////////////////////////////////////////////////////

/datum/job/vamp/garou/spiral/executive
	title = "Endron Branch Executive"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Endron International")
	faction = "Vampire"

	total_positions = 4
	spawn_positions = 4
	supervisors = "The Board, The Branch Lead and Yourself"
	selection_color = "#015334"

	minimal_renownrank = 2
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 150
	exp_type_department = EXP_TYPE_SPIRAL

	outfit = /datum/outfit/job/garou/endronexec

	access = list(ACCESS_ROBOTICS, ACCESS_RND, ACCESS_TOXINS, ACCESS_TOXINS_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_TECH_STORAGE, ACCESS_GENETICS, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_RND, ACCESS_TOXINS, ACCESS_TOXINS_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_ENDRONEXEC

	minimal_masquerade = 4
	max_generation = 9
	allowed_species = list("Werewolf", "Ghoul", "Human", "Vampire")
	allowed_tribes = list("Black Spiral Dancers")
	allowed_bloodlines = list("Daughters of Cacophony", "Salubri", "Baali", "Brujah", "True Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "City Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Banu Haqim Sorcerer", "Banu Haqim Vizier", "Giovanni", "Followers of Set", "Tzimisce", "Lasombra", "Kiasyd", "Cappadocian", "Salubri Warrior", "Caitiff")
	species_slots = list("Vampire" = 1, "Werewolf" = 1)

	my_contact_is_important = TRUE
	known_contacts = list("Endron Employee", "Endron Security Agent", "Endron Chief of Security", "Endron Branch Lead")

	v_duty = "You are an acting executive for the Endron Oil Refinery, operating out of San Francisco. With discretion to the Branch Leader, a position you may aim for, your job is to fuel production, aid in bringing forth banes, and sate the heads of the Wyrm. Expand!"

/datum/outfit/job/garou/endronexec
	name = "Endron Branch Executive"
	jobtype = /datum/job/vamp/garou/spiral/executive

	ears = /obj/item/p25radio
	id = /obj/item/card/id/vamp/garou/spiral/executive
	uniform =  /obj/item/clothing/under/pentex/pentex_suit
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/endron_exec
	r_pocket = /obj/item/vamp/keys/pentextop
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard/rich=1)

/datum/outfit/job/garou/endronexec/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/pentex/pentex_suitskirt
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/garou/spiral/executive
	name = "Endron Branch Executive"
	icon_state = "Clerk"

///////////////////////////////////////////////////////////////////////////////////////////////

/datum/job/vamp/garou/spiral/employee
	title = "Endron Employee"
	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf")
	department_head = list("Endron International")
	allowed_tribes = list("Black Spiral Dancers", "Ronin")
	allowed_bloodlines = list("Daughters of Cacophony", "Salubri", "Baali", "Brujah", "True Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "City Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Banu Haqim Sorcerer", "Banu Haqim Vizier", "Giovanni", "Followers of Set", "Tzimisce", "Lasombra", "Kiasyd", "Cappadocian", "Salubri Warrior", "Caitiff")
	faction = "Vampire"
	selection_color = "#015334"

	total_positions = 6
	spawn_positions = 6
	supervisors = "The Branch Lead"

	req_admin_notify = 1
	minimal_player_age = 25
	max_generation = 11
	exp_requirements = 50
	exp_type_department = EXP_TYPE_SPIRAL

	outfit = /datum/outfit/job/garou/endron

	access = list(ACCESS_ROBOTICS, ACCESS_RND, ACCESS_TOXINS, ACCESS_TOXINS_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_TECH_STORAGE, ACCESS_GENETICS, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_RND, ACCESS_TOXINS, ACCESS_TOXINS_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_ENDRON

	minimal_masquerade = 3

	v_duty ="You are an employee for the Endron Oil Refinery, operating out of San Francisco. Your bosses can be a little strange; give credence to the security team and executives for tasks on the night shift, and avoid getting negative attention from the branch manager."

/datum/outfit/job/garou/endron
	name = "Endron Employee"
	jobtype = /datum/job/vamp/garou/spiral/employee

	ears = /obj/item/p25radio
	id = /obj/item/card/id/vamp/garou/spiral/employee
	uniform = /obj/item/clothing/under/pentex/pentex_longleeve
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/pentex
	l_pocket = /obj/item/vamp/phone/endron_employee
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/garou/spiral/employee
	name = "Endron Employee"
	icon_state = "Camarilla Agent"
