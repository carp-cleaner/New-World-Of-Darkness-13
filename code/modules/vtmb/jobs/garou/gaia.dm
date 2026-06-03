/datum/job/vamp/garou/westerneye/voice
	title = "Voice of the Goddess"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("United States Forest Service")
	faction = "Vampire"

	minimal_renownrank = 3
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Litany and Yourself"
	selection_color = "#a8c74d"

	req_admin_notify = 1
	minimal_player_age = 25
	exp_type_department = EXP_TYPE_GAIA

	outfit = /datum/outfit/job/garou/westerneye_voice

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_WESTERNEYEVOICE

	minimal_masquerade = 4
	allowed_species = list("Werewolf")
	allowed_tribes = list("Wendigo", "Ghost Council", "Silver Fangs")

	v_duty = "You, along with any of the other two council members present, oversee the fate of the Sept. Your duty is to ensure the Keeper, the Truthfinder, and the Warder are able to keep the peace in the Sept, and to do your utmost to keep your territory clean of banes."
	experience_addition = 0

/datum/outfit/job/garou/westerneye_voice
	name = "Voice of the Goddess"
	jobtype = /datum/job/vamp/garou/westerneye/voice

	id = /obj/item/card/id/vamp/garou/park
	uniform =  /obj/item/clothing/under/vampire/office
	suit = /obj/item/clothing/suit/vampire/coat
	shoes = /obj/item/clothing/shoes/vampire/brown
	l_pocket = /obj/item/vamp/phone/westerneye_voice
	r_pocket = /obj/item/vamp/keys/ranger
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/garou/westerneye/voice
	name = "Voice of the Goddess"
	icon_state = "Prince"

///////////////////////////////////////////////////////////////////////////////////////////////

/datum/job/vamp/garou/westerneye/arm
	title = "Arm of the Goddess"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("United States Forest Service")
	faction = "Vampire"

	minimal_renownrank = 3
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Litany and the Council"
	selection_color = "#a8c74d"

	req_admin_notify = 1
	minimal_player_age = 25
	exp_type_department = EXP_TYPE_GAIA

	outfit = /datum/outfit/job/garou/westerneye_arm

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM, TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_WESTERNEYEARM

	minimal_masquerade = 4
	allowed_species = list("Werewolf")
	allowed_tribes = list("Wendigo", "Ghost Council", "Silver Fangs")

	v_duty = "You are the keeper of your Sept's grounds. Your duty is to look after those with access to the caerns and bawns to ensure things remain pleasing to the spirits, and to ensure rites and rituals go well. Keep an eye on the land, and entrust your sept with keeping others in line."

/datum/outfit/job/garou/westerneye_arm
	name = "Park Chief Ranger"
	jobtype = /datum/job/vamp/garou/westerneye/arm

	id = /obj/item/card/id/vamp/garou/park/chief
	head = /obj/item/clothing/head/fedora/beige
	uniform =  /obj/item/clothing/under/vampire/ranger
	shoes = /obj/item/clothing/shoes/vampire/brown
	l_pocket = /obj/item/vamp/phone/westerneye_arm
	r_pocket = /obj/item/vamp/keys/ranger
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/m1911 = 1, /obj/item/ammo_box/magazine/vampire/vamp45acp = 1, /obj/item/veil_contract=1, /obj/item/passport=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/garou/westerneye/arm
	name = "Arm of the Goddess"
	icon_state = "Sheriff"

///////////////////////////////////////////////////////////////////////////////////////////////

/datum/job/vamp/garou/westerneye/ranger
	title = "Park Ranger"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("United States Forest Service")
	faction = "Vampire"

	total_positions = 6
	spawn_positions = 6
	supervisors = "Park Manager"
	selection_color = "#a8c74d"

	req_admin_notify = 1
	minimal_player_age = 25
	exp_type_department = EXP_TYPE_GAIA

	outfit = /datum/outfit/job/garou/westerneye_ranger

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_WESTERNEYERANGER

	allowed_species = list("Werewolf", "Human", "Kuei-Jin", "Vampire")
	allowed_tribes = list("Glass Walkers", "Wendigo", "Ghost Council", "Silver Fangs")
	allowed_bloodlines = list("Gangrel")
	max_generation = 11

	v_duty = "You are an acting security for the Endron Oil Refinery, operating out of San Francisco. Under the chief of security's direction, your job is to keep the complex free of nosy meddlers, pick up contract violators, and to assist the chief in tackling threats to corporate assets."

/datum/outfit/job/garou/westerneye_ranger
	name = "Park Ranger"
	jobtype = /datum/job/vamp/garou/westerneye/ranger

	id = /obj/item/card/id/vamp/garou/park/ranger
	head = /obj/item/clothing/head/fedora/beige
	uniform =  /obj/item/clothing/under/vampire/ranger
	shoes = /obj/item/clothing/shoes/vampire/brown
	l_pocket = /obj/item/vamp/phone/westerneye_ranger
	r_pocket = /obj/item/vamp/keys/ranger
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/m1911 = 1, /obj/item/ammo_box/magazine/vampire/vamp45acp = 1, /obj/item/passport=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/garou/westerneye/ranger
	name = "Park Ranger"
	icon_state = "Camarilla Agent"
