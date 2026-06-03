/datum/job/vamp/police_officer
	title = "Police Officer"
	department_head = list("Police Department")
	faction = "Vampire"
	total_positions = 6
	spawn_positions = 6
	supervisors = "Lieutenant and Sergeants"
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/police_officer

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_ARMORY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE
	exp_type_department = EXP_TYPE_POLICE

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	allowed_species = list("Ghoul", "Human")

	duty = "Enforce the Law, obey the SFPD Chief and Sergeants. Gold in peace, iron in war."
	minimal_masquerade = 4
	known_contacts = list("Lieutenant")

/datum/outfit/job/police_officer
	name = "Police Officer"
	jobtype = /datum/job/vamp/police_officer

	ears = /obj/item/p25radio/police
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police
	belt = /obj/item/storage/belt/holster/detective/vampire/police
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/vamp/police
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/police
	backpack_contents = list(/obj/item/melee/classic_baton/vampire=1, /obj/item/passport=1, /obj/item/ammo_box/vampire/c9mm=1, /obj/item/gun/ballistic/automatic/vampire/glock19=1, /obj/item/ammo_box/magazine/vampire/glock9mm=1, /obj/item/radio/cop=1, /obj/item/vamp/creditcard=1, /obj/item/storage/box/handcuffs=1, /obj/item/food/donut/choco=1, /obj/item/storage/firstaid/ifak=1)

/datum/outfit/job/police_officer/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/martial_art/MA = new /datum/martial_art/police_jiu
	H.ignores_warrant = TRUE
	MA.teach(H)
	H.add_police_codes()

/obj/effect/landmark/start/police_officer
	name = "Police Officer"
	icon_state = "Officer"

/datum/job/vamp/police_coroner
	title = "Police Coroner"
	department_head = list("Police Coroner")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Lieutenant"
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/police_coroner

	access = list(ACCESS_HYDROPONICS, ACCESS_ARMORY, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE_CORONER
	exp_type_department = EXP_TYPE_POLICE

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	allowed_species = list("Ghoul", "Human")

	duty = "Investigate crimes. Obey the SFPD Chief. Gold in peace, iron in war."
	minimal_masquerade = 4
	known_contacts = list("Lieutenant")

/datum/outfit/job/police_coroner
	name = "Police Coroner"
	jobtype = /datum/job/vamp/police_coroner

	ears = /obj/item/p25radio/police
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/labcoat
	belt = /obj/item/defibrillator/compact/loaded
	gloves = /obj/item/clothing/gloves/vampire/latex
	id = /obj/item/card/id/vamp/police/coroner
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/police
	backpack_contents = list(/obj/item/screwdriver=1, /obj/item/passport=1, /obj/item/ammo_box/vampire/c9mm=1, /obj/item/gun/ballistic/automatic/vampire/glock19=1, /obj/item/ammo_box/magazine/vampire/glock9mm=1, /obj/item/cockclock=1, /obj/item/radio/cop=1, /obj/item/vamp/creditcard=1, /obj/item/storage/firstaid/regular=1)

/datum/outfit/job/police_coroner/post_equip(mob/living/carbon/human/H)
	..()
	H.ignores_warrant = TRUE
	H.add_police_codes()

/obj/effect/landmark/start/police_coroner
	name = "Police Coroner"
	icon_state = "Camarilla Agent"

/datum/job/vamp/police_sergeant
	title = "Police Sergeant"
	department_head = list("Police Department")
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Lieutenant"
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/police_sergeant

	access = list(ACCESS_HYDROPONICS, ACCESS_ARMORY, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE_SERGEANT
	exp_type_department = EXP_TYPE_POLICE

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	allowed_species = list("Human")

	duty = "Enforce the law. Keep the officers in line. Obey the SFPD Chief. Gold in peace, iron in war."
	minimal_masquerade = 4
	known_contacts = list("Lieutenant")

/datum/outfit/job/police_sergeant
	name = "Police Sergeant"
	jobtype = /datum/job/vamp/police_sergeant

	ears = /obj/item/p25radio/police/supervisor
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police/sergeant
	belt = /obj/item/storage/belt/holster/detective/vampire/police
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/vamp/police/sergeant
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/police/secure
	backpack_contents = list(/obj/item/melee/classic_baton/vampire=1, /obj/item/passport=1, /obj/item/ammo_box/vampire/c9mm=1, /obj/item/gun/ballistic/automatic/vampire/glock19=1, /obj/item/ammo_box/magazine/vampire/glock9mm=1, /obj/item/radio/cop=1, /obj/item/vamp/creditcard=1, /obj/item/storage/box/handcuffs=1 , /obj/item/food/donut/choco = 1, /obj/item/storage/firstaid/ifak=1)

/datum/outfit/job/police_sergeant/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/martial_art/MA = new /datum/martial_art/police_jiu
	H.ignores_warrant = TRUE
	MA.teach(H)
	H.add_police_codes()

/obj/effect/landmark/start/police_sergeant
	name = "Police Sergeant"
	icon_state = "Sergeant"

/datum/job/vamp/police_lieutenant
	title = "Police Lieutenant"
	department_head = list("Police Department")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "SFPD Chief"
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/police_lieutenant

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_ARMORY, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE_LIEUTENANT
	exp_type_department = EXP_TYPE_POLICE

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	allowed_species = list("Ghoul", "Human")

	duty = "Do your best to keep the order in San Francisco. Keep the officers in line. Gold in peace, iron in war."
	minimal_masquerade = 4

/datum/outfit/job/police_lieutenant
	name = "Police Lieutenant"
	jobtype = /datum/job/vamp/police_lieutenant

	ears = /obj/item/p25radio/police/command
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police/chief/lieutenant
	belt = /obj/item/storage/belt/holster/detective/vampire/police
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/vamp/police/lieutenant
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/police/secure/lieutenant
	backpack_contents = list(/obj/item/melee/classic_baton/vampire=1, /obj/item/passport=1, /obj/item/ammo_box/vampire/c9mm=1, /obj/item/gun/ballistic/automatic/vampire/glock19=1, /obj/item/ammo_box/magazine/vampire/glock9mm=1, /obj/item/radio/cop=1, /obj/item/vamp/creditcard=1, /obj/item/storage/box/handcuffs=1, /obj/item/food/donut/choco=1, /obj/item/storage/firstaid/ifak=1)

/datum/outfit/job/police_lieutenant/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/martial_art/MA = new /datum/martial_art/police_jiu
	H.ignores_warrant = TRUE
	MA.teach(H)
	H.add_police_codes()

/obj/effect/landmark/start/police_lieutenant
	name = "Police Lieutenant"
	icon_state = "Lieutenant"
