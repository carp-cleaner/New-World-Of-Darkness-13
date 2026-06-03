/datum/job/vamp/dealer
	title = "Dealer"
	department_head = list("Union Pacific Railroad")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "City Authorities"
	selection_color = "#a59344"
	exp_type_department = EXP_TYPE_WAREHOUSE // This is so the jobs menu can work properly

	outfit = /datum/outfit/job/dealer

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_VAULT, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_VAULT, ACCESS_AUX_BASE)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_CAR

	liver_traits = list(TRAIT_PRETENDER_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_DEALER
	bounty_types = CIV_JOB_RANDOM

	allowed_species = list("Vampire", "Ghoul", "Human", "Kuei-Jin", "Werewolf")
	allowed_bloodlines = list("Brujah", "True Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "City Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Banu Haqim Sorcerer", "Banu Haqim Vizier", "Giovanni", "Followers of Set", "Lasombra", "Caitiff")
	allowed_tribes = list("Glass Walkers", "Bone Gnawers")

	v_duty = "You provide supplies to other kindred. The warehouse is yours, and it's your business who you'll deal with."
	minimal_masquerade = 3
	experience_addition = 0
	minimal_generation = 11
	max_generation = 9

/datum/outfit/job/dealer
	name = "Dealer"
	jobtype = /datum/job/vamp/dealer

	id = /obj/item/card/id/vamp/dealer
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/dealer
	r_pocket = /obj/item/vamp/keys/supply
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard/rich=1)

/datum/outfit/job/dealer/pre_equip(mob/living/carbon/human/H)
	..()
	//H.vampire_faction = "Anarchs"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/dealer
	name = "Dealer"
	icon_state = "Dealer"

////////////////////////////////////////////////////////////////////////////////////////

/datum/job/vamp/supply
	title = "Supply Technician"
	department_head = list("Union Pacific Railroad")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Dealer"
	selection_color = "#a59344"
	exp_type_department = EXP_TYPE_WAREHOUSE

	outfit = /datum/outfit/job/supply

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM, ACCESS_MECH_MINING)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_CAR
	display_order = JOB_DISPLAY_ORDER_SUPPLY
	bounty_types = CIV_JOB_RANDOM
	allowed_species = list("Vampire", "Ghoul", "Human", "Kuei-Jin", "Werewolf")
	allowed_bloodlines = list("Brujah", "True Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "City Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Banu Haqim Sorcerer", "Banu Haqim Vizier", "Giovanni", "Followers of Set", "Lasombra", "Caitiff")
	allowed_tribes = list("Glass Walkers", "Bone Gnawers")
	v_duty = "You work for the Dealer, or are a part of their coterie. They pay well and the job is easy. Don't disappoint them."
	duty = "Though your boss is odd and only works late night hours, they pay you well enough that you avoid questioning it."
	minimal_masquerade = 3
	max_generation = 10
	experience_addition = 0

/datum/outfit/job/supply
	name = "Supply Technician"
	jobtype = /datum/job/vamp/supply

	id = /obj/item/card/id/vamp/supplytech
	uniform = /obj/item/clothing/under/vampire/supply
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/phone/supply_tech
	r_pocket = /obj/item/vamp/keys/supply
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/supplytechnician
	name = "Supply Technician"
	icon_state = "Supply Technician"
