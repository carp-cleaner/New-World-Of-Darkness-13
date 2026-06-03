/datum/vampireclane/gangrel/city
	name = "City Gangrel"
	desc = "Гангрелы приспособленные к городской среде. Антитрибу шабаша. Городские Гангрелы – великолепные городские хищники, они оттачивают свои инстинкты для удовлетворения своей жажды."
	clane_disciplines = list(
		/datum/discipline/celerity,
		/datum/discipline/obfuscate,
		/datum/discipline/protean
	)
	start_humanity = 6
	whitelisted = TRUE
	male_clothes = /obj/item/clothing/under/vampire/gangrel
	female_clothes = /obj/item/clothing/under/vampire/gangrel/female
	current_accessory = "none"
	accessories = list("beast_legs", "beast_tail", "beast_tail_and_legs", "none")
	accessories_layers = list("beast_legs" = UNICORN_LAYER+1, "beast_tail" = UNICORN_LAYER, "beast_tail_and_legs" = UNICORN_LAYER, "none" = UNICORN_LAYER)
