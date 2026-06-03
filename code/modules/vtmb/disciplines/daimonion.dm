/datum/discipline/daimonion
	name = "Daimonion"
	desc = "Draw power from the demons and infernal nature of Hell. Use subtle power to manipulate people and when you must, draw upon fire itself and protect yourself."
	icon_state = "daimonion"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/daimonion

/datum/discipline_power/daimonion
	name = "Daimonion power name"
	desc = "Daimonion power description"

	cooldown_length = 15 SECONDS

	activate_sound = 'code/modules/wod13/sounds/protean_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/protean_deactivate.ogg'

//SENSE THE SIN
/datum/discipline_power/daimonion/sense_the_sin
	name = "Sense the Sin"
	desc = "Sense the weakness."

	level = 1
	range = 7

	target_type = TARGET_HUMAN

/datum/discipline_power/daimonion/sense_the_sin/pre_activation_checks(mob/living/target)
	var/selfcontrol = 3
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		selfcontrol = H.MyPath?.selfcontrol
	var/success_chance = secret_vampireroll(get_a_perception(target)+get_a_empathy(target), selfcontrol+4, owner, TRUE)
	if(success_chance <= 0)
		to_chat(owner, span_notice("Твоя магия угасла!"))
		owner.Stun(3 SECONDS, TRUE)
		return FALSE
	return TRUE

/datum/discipline_power/daimonion/sense_the_sin/activate(mob/living/carbon/human/target)
	. = ..()
	if(!HAS_TRAIT(target, TRAIT_SENSE_THE_SIN))
		ADD_TRAIT(target, TRAIT_SENSE_THE_SIN, DISCIPLINE_TRAIT)
		addtimer(CALLBACK(src, PROC_REF(timer_deactivation), target), 60 SECONDS)
	if(get_a_strength(target) <= 4)
		to_chat(owner, span_notice("Слабые руки выдают их немощь."))
	if(get_a_dexterity(target) <= 4)
		to_chat(owner, span_notice("Они спотыкаются там, где другие скользят — неуклюжи и неуравновешенны."))
	if(get_a_stamina(target) <= 4)
		to_chat(owner, span_notice("Их силы иссякают ещё до начала борьбы."))
	if(get_a_charisma(target) <= 4)
		to_chat(owner, span_notice("Их слова капают тусклостью и падают мёртвыми на землю."))
	if(get_a_manipulation(target) <= 4)
		to_chat(owner, span_notice("Интриги рассыпаются в их руках — никто не верит их обману."))
	if(get_a_appearance(target) <= 4)
		to_chat(owner, span_notice("Вид их — бремя, а не благословение."))
	if(get_a_perception(target) <= 4)
		to_chat(owner, span_notice("Слепы к тонкостям — мир шепчет мимо них."))
	if(get_a_intelligence(target ) <= 4)
		to_chat(owner, span_notice("Их разум — пустое поле, не дающее урожая мыслей."))
	if(get_a_wits(target) <= 4)
		to_chat(owner, span_notice("Искра проницательности ускользает от них."))
	if(get_a_willpower(target) <= 4)
		to_chat(owner, span_notice("Их дух гнётся, как тростник перед бурей."))

	if(iskindred(target))
		to_chat(owner, span_notice("\nСтрах огня плотно обвивает их душу.\n"))
		if(target.MyPath)
			if(target.MyPath.willpower <= 5)
				to_chat(owner, span_notice("Их решимость колеблется, как свеча на ветру."))
			if(target.MyPath.consience <= 2)
				to_chat(owner, span_notice("Моральный компас разбит — они бредут в тенях сомнения."))
			if(target.MyPath.selfcontrol <= 2)
				to_chat(owner, span_notice("Импульс правит в них — оковы сдержанности разорваны."))
			if(target.MyPath.courage <= 2)
				to_chat(owner, span_notice("Страх сжимает их сердце — даже шёпот кажется рёвом."))
		baali_get_moral_failings(target)
		baali_get_stolen_disciplines(target)
		if(target.generation >= 10)
			to_chat(owner, span_notice("Их кровь мелка и пуста перед могуществом древних."))
		else
			to_chat(owner, span_notice("Их кровь гудит первобытной силой, сопротивляясь разбавлению."))

	else if(isghoul(target))
		if(target.mind.enslaved_to)
			to_chat(owner, span_notice("Привязаны к вампирской витэ — их воля скована силой, превосходящей их."))
		else
			to_chat(owner, span_notice("Их жажда вампирской крови течёт свободно, ведома лишь собственной волей."))

	else if(isgarou(target) || iswerewolf(target))
		to_chat(owner, span_notice("\nИх плоть содрогается от прикосновения серебра — проклятие древнее их памяти."))
		if(target.client?.prefs?.breed == BREED_HOMID)
			to_chat(owner, span_notice("Между пульсом природы и усыплением человечества их сила колеблется в нерешительности."))
		else if(target.client?.prefs?.breed == BREED_LUPUS)
			to_chat(owner, span_notice("Они бродят с силой дикой природы, но человеческая хитрость сбивает их простые умы."))
		else if(target.client?.prefs?.breed == BREED_METIS)
			to_chat(owner, span_notice("Рождённые запретным союзом, они идут в огромном облике — но изъян и ярость таятся в каждом шаге."))

		if(target.client?.prefs?.tribe == "Wendigo")
			to_chat(owner, span_notice("Пропитанные холодом и скрытностью тотема, они слабеют, оторванные от чистоты дикой природы."))
		else if(target.client?.prefs?.tribe == "Glasswalkers")
			to_chat(owner, span_notice("Их сила растёт с каждым новшеством, но комфорт прогресса притупляет инстинкты."))
		else if(target.client?.prefs?.tribe == "Black Spiral Dancers")
			to_chat(owner, span_notice("Искажённые тьмой и яростью, их сила огромна — но семя безумия точит каждую мысль."))

	else if(iscathayan(target))
		to_chat(owner, span_notice("\nИх некогда падшая душа дрейфует между жизненной силой и тлением."))
		if(target.mind.dharma?.name == "Devil Tiger (P'o)")
			to_chat(owner, span_notice("Быстры в действии, ведомы скрытым голодом — их движения выдают беспокойный, опасный умысел."))
		else if(target.mind.dharma?.name == "Song of the Shadow (Yin)")
			to_chat(owner, span_notice("Холодны как кость, дрейфуют во тьме — их присутствие тревожит сердца и отключает умы."))
		else if(target.mind.dharma?.name == "Resplendent Crane (Hun)")
			to_chat(owner, span_notice("Тени прошлых прегрешений цепко держатся — невидимая тяжесть формирует каждый шаг."))
		else if(target.mind.dharma?.name == "Thrashing Dragon (Yang)")
			to_chat(owner, span_notice("Голод движет каждым поступком — беспокойный огонь пожирает и себя, и других, скрывая грызущее сомнение."))
		else if(target.mind.dharma?.name == "Flame of the Rising Phoenix (Yang+Hun)")
			to_chat(owner, span_notice("Шёпот голода и дисбаланса омрачает каждый шаг — даже самых преданных ведёт к падению и тихой гибели."))

		if(target.mind.dharma?.Po == "Legalist")
			to_chat(owner, span_notice("Наложенный порядок искривляет их душу в безмолвный бунт."))
		else if(target.mind.dharma?.Po == "Rebel")
			to_chat(owner, span_notice("Они вздрагивают от прикосновения, охраняя свободу как священное пламя."))
		else if(target.mind.dharma?.Po == "Monkey")
			to_chat(owner, span_notice("Мимолётные радости и лёгкая выгода дёргают их, как шаловливые нити."))
		else if(target.mind.dharma?.Po == "Demon")
			to_chat(owner, span_notice("Боль пленяет их — нанесённая и переносимая, зависимость в жилах."))
		else if(target.mind.dharma?.Po == "Fool")
			to_chat(owner, span_notice("Они съёживаются от внимания — смех обращает их взгляд внутрь с неловкостью."))
	else
		to_chat(owner, span_notice("Хрупкое создание — ни могучее, ни отмеченное слабостью."))

/datum/discipline_power/daimonion/sense_the_sin/proc/timer_deactivation(mob/living/target)
	if(HAS_TRAIT(target, TRAIT_SENSE_THE_SIN))
		REMOVE_TRAIT(target, TRAIT_SENSE_THE_SIN, DISCIPLINE_TRAIT)

/datum/discipline_power/daimonion/sense_the_sin/proc/baali_get_moral_failings(target)
	var/mob/living/carbon/human/H = target
	var/clan_messages = list(
		"Toreador" = "Одержимы до крайности — мысли кружатся бесконечно.",
		"Daughters of Cacophony" = "Их разум тонет в нескончаемой музыке.",
		"Ventrue" = "Кровь бедняков не трогает их дух.",
		"Lasombra" = "Страх перемен сжимает их, не отпуская.",
		"Tzimisce" = "В них одно желание, пылающее как огонь и пожирающее всё остальное.",
		"Old Clan Tzimisce" = "Пропитаны древней гордыней, связи глубоки и цепки — но зрение затуманено тысячелетними обидами.",
		"Gangrel" = "Импульсы бьют без удержу, разум ускользает.",
		"City Gangrel" = "Импульсы бьют без удержу, разум ускользает.",
		"Malkavian" = "Их присутствие тревожит всех вокруг, искажая восприятие.",
		"Brujah" = "Их гнев тлеет — рождён давно похоронным стыдом.",
		"Nosferatu" = "Их неудержимо тянет к сокрытым истинам и неведомым путям.",
		"Tremere" = "Перфекционизм в каждом действии гонит неумолимую погоню.",
		"Baali" = "Они трепещут перед незримыми силами, вечно в страхе.",
		"Banu Haqim" = "Их суждение абсолютно и неумолимо в каждой мысли.",
		"Banu Haqim Sorcerer" = "Магия прилипла к душе — пятно, которое не скрыть завесой.",
		"Banu Haqim Vizier" = "Знание пожирает их, как огонь — пергамент.",
		"True Brujah" = "Их эмоции заперты глубоко — раскрыть невозможно.",
		"Salubri" = "Связаны согласием — каждый выбор даётся тяжело.",
		"Salubri Warrior" = "Связаны священным долгом — решимость неколебима, но каждый шаг несёт груз проигранных битв.",
		"Giovanni" = "Для них нет поступка слишком великого, если он служит семье.",
		"Cappadocian" = "Их бесконечно преследует отражение смерти.",
		"Kiasyd" = "Холодное железо леденит их сильнее плоти, вселяя страх.",
		"Gargoyle" = "Их разум — крепость с распахнутыми воротами.",
		"Followers of Set" = "Любое пятно греха они обращают в добродетель."
	)

	var/message = clan_messages[H.clane?.name]
	if(!message)
		message = "Их бросил холодный океан ночи — некому удержать на плаву."
	to_chat(owner, span_notice(message))

/datum/discipline_power/daimonion/sense_the_sin/proc/baali_get_stolen_disciplines(target)
	var/mob/living/carbon/human/H = target
	var/datum/species/kindred/clan = H.dna.species
	var/discipline_owners = list(
		"Quietus" = list("Banu Haqim"),
		"Protean" = list("Gangrel", "City Gangrel"),
		"Serpentis" = list("Followers of Set"),
		"Necromancy" = list("Giovanni", "Cappadocian"),
		"Obtenebration" = list("Lasombra"),
		"Dementation" = list("Malkavian"),
		"Vicissitude" = list("Tzimisce"),
		"Melpominee" = list("Daughters of Cacophony"),
		"Daimonion" = list("Baali"),
		"Temporis" = list("True Brujah"),
		"Visceratika" = list("Gargoyle"),
		"Thaumaturgy: Path of Blood" = list("Tremere"),
		"Thaumaturgy: Path of Conjuring" = list("Tremere"),
		"Thaumaturgy: The Lure of Flames" = list("Tremere"),
		"Thaumaturgy: Path of the Levinbolt" = list("Tremere"),
		"Dark Thaumaturgy: The Fires of the Inferno" = list("Baali"),
		"Dark Thaumaturgy: Path of Pain" = list("Baali"),
		"Dark Thaumaturgy: The Taking of the Spirit" = list("Baali"),
		"Healer Valeren" = list("Salubri", "Salubri Warrior"),
		"Warrior Valeren" = list("Salubri", "Salubri Warrior"),
		"Mytherceria" = list("Kiasyd"),
		"Du-Ran-Ki: Awakening of the Steel" = list("Banu Haqim Sorcerer"),
		"Du-Ran-Ki: Path of Blood" = list("Banu Haqim Sorcerer"),
		"Setite Sorcery: Path of Duat" = list("Followers of Set")
	)
	for(var/discipline in discipline_owners)
		if(clan.get_discipline(discipline) && !(H.clane?.name in discipline_owners[discipline]))
			to_chat(owner, span_notice("[H] боится, что станет известно, что они украли [discipline] у [discipline_owners[discipline][1]]."))


//FEAR OF THE VOID BELOW
/datum/discipline_power/daimonion/fear_of_the_void_below
	name = "Fear of the Void Below"
	desc = "Induce fear in a target."

	level = 2
	range = 7
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING | DISC_CHECK_IMMOBILE
	target_type = TARGET_HUMAN | TARGET_VAMPIRE

/datum/discipline_power/daimonion/fear_of_the_void_below/pre_activation_checks(mob/living/target)
	if(!HAS_TRAIT(target, TRAIT_SENSE_THE_SIN))
		to_chat(owner, span_notice("Сначала нужно применить Чувствовать грех на них!"))
		return FALSE
	var/courage = 3
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		courage = H.MyPath?.courage
	var/success_chance = secret_vampireroll(get_a_wits(target)+get_a_intimidation(target), courage+4, owner)
	if(success_chance <= 0)
		to_chat(owner, span_notice("Твоя магия угасла!"))
		owner.Stun(3 SECONDS, TRUE)
		owner.do_jitter_animation(10)
		return FALSE
	return TRUE

/datum/discipline_power/daimonion/fear_of_the_void_below/activate(mob/living/carbon/human/target)
	. = ..()
	var/mob/living/carbon/human/frenzied_target = target
	if(iskindred(frenzied_target))
		if(!frenzied_target.in_frenzy) // Cause target to frenzy
			frenzied_target.enter_frenzymod()
			addtimer(CALLBACK(frenzied_target, TYPE_PROC_REF(/mob/living/carbon, exit_frenzymod)), 5 SECONDS)
	else
		if(!(frenzied_target.stat >= UNCONSCIOUS || frenzied_target.IsSleeping() || frenzied_target.IsUnconscious()))
			frenzied_target.Sleeping(20)
	frenzied_target.overlay_fullscreen("STRAH", /atom/movable/screen/fullscreen/yomi_world)
	frenzied_target.clear_fullscreen("STRAH", 3)


//CONFLAGRATION
/datum/discipline_power/daimonion/conflagration
	name = "Conflagration"
	desc = "Draw out the destructive essence of the Beyond."

	level = 3
	range = 7
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE
	hostile = TRUE
	target_type = TARGET_MOB | TARGET_OBJ | TARGET_TURF

/datum/discipline_power/daimonion/conflagration/pre_activation_checks(mob/living/target)
	var/success_chance = secret_vampireroll(get_a_dexterity(target)+get_a_occult(target), 6, owner)
	if(success_chance <= 0)
		to_chat(owner, span_notice("Your magic fizzles out!"))
		owner.Stun(3 SECONDS, TRUE)
		owner.do_jitter_animation(10)
		return FALSE
	return TRUE

/datum/discipline_power/daimonion/conflagration/activate(atom/target)
	. = ..()
	var/turf/start = get_turf(owner)
	var/obj/projectile/magic/aoe/fireball/baali/created_fireball = new(start)
	created_fireball.firer = owner
	created_fireball.preparePixelProjectile(target, start)
	created_fireball.fire(direct_target = target)

//PSYCHOMACHIA
/datum/discipline_power/daimonion/psychomachia
	name = "Psychomachia"
	desc = "Bring forth the target's greatest fear."

	level = 4
	range = 7
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	target_type = TARGET_HUMAN

	target_type = TARGET_HUMAN


/datum/discipline_power/daimonion/psychomachia/pre_activation_checks(mob/living/target)
	if(!HAS_TRAIT(target, TRAIT_SENSE_THE_SIN))
		to_chat(owner, span_notice("Сначала нужно применить Чувствовать грех на них!"))
		return FALSE
	var/lowest_stat = 2
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		lowest_stat = min(H.MyPath?.consience, H.MyPath?.courage, H.MyPath?.selfcontrol)
	var/success_chance = secret_vampireroll(lowest_stat, 6, target)
	if(success_chance <= 0)
		to_chat(owner, span_notice("Твоя магия угасла!"))
		owner.Stun(3 SECONDS, TRUE)
		owner.do_jitter_animation(10)
		return FALSE
	return TRUE

/datum/discipline_power/daimonion/psychomachia/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, "<span class='warning'><b>You hear infernal laugh!</span></b>")
	new /datum/hallucination/baali(target, TRUE)

//CONDEMNTATION
/datum/discipline_power/daimonion/condemnation
	name = "Condemnation"
	desc = "CURSE OF VTM13."

	level = 5
	range = 7
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	target_type = TARGET_HUMAN | TARGET_LIVING

	var/initialized_curses = FALSE //can't do this in new since it wouldn't have assigned owner yet. this will do.
	var/list/curse_names = list()
	var/list/curses = list()

/datum/discipline_power/daimonion/condemnation/pre_activation_checks(mob/living/target)
	var/success_chance = secret_vampireroll(get_a_intelligence(owner)+get_a_occult(owner), get_a_willpower(target), target)
	if(success_chance <= 0)
		to_chat(owner, span_notice("Your magic fizzles out!"))
		owner.Stun(3 SECONDS, TRUE)
		owner.do_jitter_animation(10)
		return FALSE
	return TRUE

/datum/discipline_power/daimonion/condemnation/activate(mob/living/carbon/human/target)
	. = ..()
	if(LAZYLEN(GLOB.cursed_characters) == 0 || LAZYLEN(GLOB.cursed_characters) > 0 && !(GLOB.cursed_characters.Find(target)))
		if(!initialized_curses)
			for(var/i in subtypesof(/datum/curse/daimonion))
				var/datum/curse/daimonion/daimonion_curse = new i
				curses += daimonion_curse
				if(owner.generation <= daimonion_curse.genrequired)
					curse_names += initial(daimonion_curse.name)
				initialized_curses = TRUE

		to_chat(owner, span_userdanger("The greatest of curses come with the greatest of costs. Are you willing to take the risk of total damnation?"))
		var/chosencurse = tgui_input_list(owner, "Pick a curse to bestow:", "Daimonion", curse_names, timeout=15 SECONDS)
		if(!chosencurse)
			return
		for(var/datum/curse/daimonion/C in curses)
			if(C.name == chosencurse)
				C.activate(target)
				owner.maxbloodpool -= C.bloodcurse
				if(owner.bloodpool > owner.maxbloodpool)
					owner.bloodpool = owner.maxbloodpool
				GLOB.cursed_characters += target
				to_chat(owner, span_notice(span_bold("You place a great infernal curse on your victim!")))
	else
		to_chat(owner, span_warning("This one is already cursed!"))

/datum/discipline_power/daimonion/condemnation/post_gain()
	. = ..()
	var/datum/action/antifrenzy/antifrenzy_contract = new()
	antifrenzy_contract.Grant(owner)

/datum/action/antifrenzy
	name = "Resist Beast"
	desc = "Resist Frenzy and Rotshreck by signing a contract with Demons."
	button_icon_state = "resist"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/used = FALSE

/datum/action/antifrenzy/Trigger()
	var/mob/living/carbon/human/user = owner
	if(user.stat >= UNCONSCIOUS || user.IsSleeping() || user.IsUnconscious() || user.IsParalyzed() || user.IsKnockdown() || user.IsStun() || HAS_TRAIT(user, TRAIT_RESTRAINED) || !isturf(user.loc))
		return
	if(used)
		to_chat(owner, span_warning("You've already signed this contract!"))
		return
	used = TRUE
	user.antifrenzy = TRUE
	SEND_SOUND(owner, sound('sound/magic/curse.ogg', 0, 0, 50))
	to_chat(owner, span_warning("You feel control over your Beast, but at what cost..."))
	qdel(src)
