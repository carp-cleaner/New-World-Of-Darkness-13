//WARRIOR VALEREN 3 - BURNING TOUCH
/datum/status_effect/burning_touch
	id = "burning_touch"
	status_type = STATUS_EFFECT_REFRESH
	duration = 6 SECONDS //Two turns
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/burning_touch
	var/mob/living/carbon/human/source

/atom/movable/screen/alert/status_effect/burning_touch
	name = "Burning Touch"
	desc = "THE PAIN!!! IT HURTS!!!"
	icon_state = "fire"

/datum/status_effect/burning_touch/on_creation(mob/living/carbon/new_owner, mob/living/carbon/human/new_source)
	. = ..()
	source = new_source

/datum/status_effect/burning_touch/tick()
	var/mob/living/carbon/grabber = owner
	if(source.pulling == grabber)
		grabber.adjustStaminaLoss(60, forced = TRUE)
		grabber.emote("scream")
		grabber.apply_status_effect(STATUS_EFFECT_BURNING_TOUCH, owner)

/datum/status_effect/burning_touch/Destroy()
	source = null
	return ..()

/datum/status_effect/delirium
	id = "delirium"
	status_type = STATUS_EFFECT_REFRESH
	duration = 15 SECONDS
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/delirium
	var/rolled_successes
	var/werewolf_source
	var/active_callback = FALSE

/atom/movable/screen/alert/status_effect/delirium
	name = "УЖАС"
	desc = "Каждое мгновение может стать последним."
	icon_state = "fear"

/datum/status_effect/delirium/on_creation(mob/living/carbon/human/H, successes_count, source)
	. = ..()
	rolled_successes = successes_count
	werewolf_source = source
	switch(rolled_successes)
		if(1)
			H.attributes.perception -= 3
			H.attributes.intelligence -= 3
			H.attributes.wits -= 3

/datum/status_effect/delirium/tick()
	var/mob/living/carbon/human/H = owner
	var/response
	switch(rolled_successes)
		if(1)
			response = pick("Н-н-нет... пожалуйста...", "Этого нет... нет...", "О боже... боже...", "Я... не хочу... умирать...", "Уй... уйди...")
			H.do_jitter_animation(3 SECONDS)
			H.add_confusion(5)
			H.dizziness += 5
			H.drowsyness += 5
			if(prob(50))
				H.emote("cry")
			if(prob(25))
				H.Unconscious(3 SECONDS)
		if(2)
			response = pick("Бегите... бегите...", "Нет... нет... нет!", "Помогите... пожалуйста!", "Оно идет... боже... оно идет!",
			"Нет времени... нужно бежать!")
			H.do_jitter_animation(3 SECONDS)
			H.dizziness += 5
			if(!active_callback)
				var/datum/cb = CALLBACK(H, TYPE_PROC_REF(/mob/living, step_away_caster), werewolf_source)
				for(var/i in 1 to 30)
					addtimer(cb, (i - 1) * H.total_multiplicative_slowdown())
					addtimer(CALLBACK(H, TYPE_PROC_REF(/datum/status_effect/delirium, reset_callback)), (i-1) * H.total_multiplicative_slowdown())
				active_callback = TRUE
			if(prob(25))
				H.emote("scream")
		if(3)
			response = pick("Это не реально... не реально...", "Я ничего не вижу... ничего...", "Сон... это просто сон...",
			"Этого нет... я сплю...", "Все пройдет... все пройдет...")
			H.do_jitter_animation(3 SECONDS)
			H.dizziness += 5
			H.add_confusion(5)
		if(4)
			response = pick("Назад!! Назад!!", "Убью... убью тебя!", "Не подходи!!", "Я тебе покажу... тварь!!", "Со мной не надо... не надо!")
			if(!H.in_frenzy) // Cause target to frenzy
				H.enter_frenzymod()
				addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon, exit_frenzymod)), 5 SECONDS)
			if(prob(25))
				H.emote("scream")
		if(5)
			response = pick("Спокойно... нужно уйти...", "Тихо... тихо... только бы выбраться...", "Держись... держись...",
			"Не смотреть... просто уйти...", "Надо найти выход... быстро!")
			H.do_jitter_animation(3 SECONDS)
			H.dizziness += 5
		if(6)
			response = pick("Пожалуйста.. не надо!", "Я все сделаю... только не трогай!", "Я не враг... я не враг...", "Прошу... пощади...",
			"Я уйду... просто отпусти...")
			H.do_jitter_animation(3 SECONDS)
			H.add_confusion(5)
		if(7)
			response = pick("Спокойно. Держись собранным.", "Не теряй голову.", "Дыши. Просто дыши.", "Смотри внимательно.", "Контроль. Держи контроль.")
			if(prob(25))
				H.do_jitter_animation(3 SECONDS)
		if(8)
			response = pick("Что это?", "Так... нужно понять...", "Это не сон. Точно - не сон.", "Интересно... очень интересно...",
			"Надо запомнить. Каждую деталь.")
		if(9)
			response = pick("Я вижу тебя, зверь.", "Вот ты какой.", "Ты мне не страшен.", "Я найду тебя потом, чудище.", "Запомнил. Теперь - ты мой.")
		if(10)
			response = pick("Понятно.", "Хм...", "Вот оно как...", "Все ясно.", "Я вижу. Продолжай...")
	if(prob(50))
		to_chat(owner, "<font size=12>[icon2html('icons/self-control.png', owner)]</font> <span class='medradio'><b>SELF-CONTROL</b></span> <span class='discosay'>[response]</span>")

/datum/status_effect/delirium/proc/reset_callback()
	active_callback = FALSE

/datum/status_effect/delirium/Destroy()
	var/mob/living/carbon/human/H = owner
	var/last_message
	switch(rolled_successes)
		if(1)
			H.attributes.perception += 3
			H.attributes.intelligence += 3
			H.attributes.wits += 3
			last_message = pick("Ты не можешь вспомнить ничего - лишь пустота в голове.", "Сознание обесточено, событие исчезло бесследно.",
			"Мысли застыли, и память о случившемся стерта.", "В голове пусто, как после отключения света.", "Ты не удержал ни секунды увиденного.")
		if(2)
			last_message = pick("Страх растворился, а память о нём исчезла.", "Ты уже не помнишь, от чего бежал.",
			"Событие стерлось, оставив лишь лёгкое напряжение.", "Сознание выбросило ужас, оставив пустоту.",
			"Воспоминание о панике уходит, будто его не было.")
		if(3)
			last_message = pick("Ты уверяешь себя, что ничего не происходило.", "Разум обрывает память и заменяет её сомнением.",
			"В голове остаётся лишь чувство нереальности.", "Ты ничего не помнишь - кажется, это был сон.",
			"Событие исчезает, оставив ничего после себя.")
		if(4)
			last_message = pick("Ярость ушла, а память о нападении исчезла.", "Ты не можешь вспомнить свои действия - только пустоту.",
			"Событие растворилось, как дым после огня.", "В голове остаётся лишь слабое ощущение хаоса.",
			"Сознание заблокировало воспоминания о твоем берсерке.")
		if(5)
			last_message = pick("Ты помнишь лишь тревогу, но детали стерты.", "Сознание вычеркнуло событие, оставив только инстинкт спасения.",
			"Паника ушла, и твоя память с ней.", "В голове остаются смутные ощущения, образы исчезли.", "Событие растворилось, словно его и не было.")
		if(6)
			last_message = pick("Все страхи утихли, и память о них исчезла.", "Ты не можешь вспомнить свои просьбы и умоления.",
			"Сознание очистилось, словно события никогда не было.", "Воспоминания о смирении растворились в пустоте.",
			"Твой разум полностью забыл о случившемся.")
		if(7)
			last_message = pick("Ты смутно помнишь произошедшее - разум сразу придумывает объяснение.",
			"Обрывки воспоминаний остаются - мозг заменяет детали привычным.",
			"Картинка расплывается - разум заполняет пробелы.", "Ты помнишь лишь искажённые фрагменты - объясняя их себе по-своему.",
			"Воспоминание тускнеет - мозг подменяет увиденное чем-то привычным.")
		if(8)
			last_message = pick("Ты помнишь произошедшее лучше - но разум рационализирует детали.",
			"Фрагменты остаются ясными - мозг ищет логическое объяснение.", "Образы частично размыты - но ты пытаешься понять.",
			"Ты помнишь многое - но сознание упорядочивает увиденное.", "Воспоминание остаётся - разум подстраивает детали под привычное.")
		if(9)
			last_message = pick("Ты ясно помнишь каждую деталь - и это не забыть.", "Воспоминание остаётся чётким - в голове всё живо.",
			"Ты удерживаешь в памяти то, что видел.", "Сознание не смогло скрыть ни одного момента.",
			"Ты полностью осознаёшь произошедшее - оно отпечатывается навсегда.")
		if(10)
			last_message = pick("Ты наблюдаешь произошедшее без эмоций.", "Сознание фиксирует факт произошедшего спокойно и холодно.",
			"Воспоминание сохранено в деталях.", "Ты держишь полный контроль над памятью.", "Произошедшее зафиксировано без искажений.")
	to_chat(owner, "<font size=12>[icon2html('icons/self-control.png', owner)]</font> <span class='medradio'><b>SELF-CONTROL</b></span> <span class='discosay'>[last_message]</span>")
	rolled_successes = null
	werewolf_source = null
	active_callback = null
	return ..()

/datum/status_effect/slow_oxyloss
	id = "slow_oxyloss"
	status_type = STATUS_EFFECT_REFRESH
	duration = 2 SECONDS
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/slow_oxyloss
	var/mob/living/carbon/human/source

/atom/movable/screen/alert/status_effect/slow_oxyloss
	name = "Losing Breath"
	desc = "YOU CAN'T BREATHE!!"
	icon_state = "slow_oxyloss"

/datum/status_effect/slow_oxyloss/on_creation(mob/living/carbon/new_owner, mob/living/carbon/human/new_source)
	. = ..()
	source = new_source

/datum/status_effect/slow_oxyloss/tick()
	owner.adjustOxyLoss(15, forced = TRUE)
	owner.emote("gasp")
	owner.apply_status_effect(STATUS_EFFECT_SLOW_OXYLOSS, owner)

/datum/status_effect/slow_oxyloss/Destroy()
	source = null
	return ..()

/datum/status_effect/slow_death
	id = "slow_death"
	status_type = STATUS_EFFECT_REFRESH
	duration = 2 SECONDS
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/slow_death
	var/mob/living/carbon/human/source
	var/timer_active = FALSE

/atom/movable/screen/alert/status_effect/slow_death
	name = "Approaching Death"
	desc = "YOU CAN'T WITHSTAND, YOUR SOUL IS BEING SIPPED AWAY!!!"
	icon_state = "slow_death"

/datum/status_effect/slow_death/on_creation(mob/living/carbon/new_owner, mob/living/carbon/human/new_source)
	. = ..()
	source = new_source

/datum/status_effect/slow_death/tick()
	owner.apply_status_effect(STATUS_EFFECT_SLOW_DEATH, owner)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		if(C.mind?.willpower_auto != TRUE)
			to_chat(owner, span_danger("Your soul trembles as Duat begins to consume it..."))
			if(!timer_active)
				addtimer(CALLBACK(src, PROC_REF(check_willpower_auto)), 15 SECONDS)
				timer_active = TRUE

/datum/status_effect/slow_death/proc/check_willpower_auto()
	if(!iscarbon(owner))
		to_chat(owner, span_bolddanger("Duat takes your soul..."))
		owner.death()
	var/mob/living/carbon/C = owner
	if(C.mind?.willpower_auto != TRUE)
		to_chat(owner, span_bolddanger("Duat takes your soul..."))
		if(iskindred(owner) || iscathayan(owner))
			owner.torpor("curse_of_ra")
		else
			owner.death()
	else
		to_chat(owner, span_bolddanger("You manage to resist Duat's relentless assaults, but it's not over yet."))
		timer_active = FALSE
		return

/datum/status_effect/slow_death/Destroy()
	source = null
	timer_active = FALSE
	return ..()

/datum/status_effect/blood_debt
	id = "blood_debt"
	duration = 999 SCENES
	alert_type = /atom/movable/screen/alert/status_effect/blood_debt
	var/debt_amount = 0
	var/initial_bloodpool = 0

/datum/status_effect/blood_debt/on_creation(mob/living/owner, spent)
	debt_amount = spent
	initial_bloodpool = owner.bloodpool
	return ..()

/datum/status_effect/blood_debt/tick()
	. = ..()
	var/blood_gained = owner.bloodpool - initial_bloodpool

	if(owner.bloodpool < initial_bloodpool)
		initial_bloodpool = owner.bloodpool

	if(blood_gained > 0)
		var/payment = min(blood_gained, debt_amount)
		owner.bloodpool -= payment
		debt_amount -= payment
		initial_bloodpool = owner.bloodpool

		if(debt_amount <= 0)
			qdel(src)

/atom/movable/screen/alert/status_effect/blood_debt
	name = "Blood Debt"
	desc = "You cannot gain blood points until your debt is paid."
	icon = 'icons/effects/effects.dmi'
	icon_state = "bhole3"
