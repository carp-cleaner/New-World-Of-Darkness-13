#define DOGGY_ANIMATION_COOLDOWN 30 DECISECONDS

/datum/action/gift
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	button_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS
	var/rage_req = 0
	var/gnosis_req = 0
	var/cool_down = 0

	var/allowed_to_proceed = FALSE

/datum/action/gift/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	button_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	. = ..()

/datum/action/gift/Trigger()
	. = ..()
	if(istype(owner, /mob/living/carbon))
		var/mob/living/carbon/H = owner
		if(H.stat == DEAD)
			allowed_to_proceed = FALSE
			return
		if(rage_req)
			if(H.auspice.rage < rage_req)
				to_chat(owner, "<span class='warning'>You don't have enough <b>RAGE</b> to do that!</span>")
				SEND_SOUND(owner, sound('code/modules/wod13/sounds/werewolf_cast_failed.ogg', 0, 0, 75))
				allowed_to_proceed = FALSE
				return
			if(H.auspice.gnosis < gnosis_req)
				to_chat(owner, "<span class='warning'>You don't have enough <b>GNOSIS</b> to do that!</span>")
				SEND_SOUND(owner, sound('code/modules/wod13/sounds/werewolf_cast_failed.ogg', 0, 0, 75))
				allowed_to_proceed = FALSE
				return
		if(cool_down+20 SECONDS >= world.time)
			allowed_to_proceed = FALSE
			return
		cool_down = world.time
		allowed_to_proceed = TRUE
		if(rage_req)
			adjust_rage(-rage_req, owner, FALSE)
		if(gnosis_req)
			adjust_gnosis(-gnosis_req, owner, FALSE)
		to_chat(owner, "<span class='notice'>You activate the [name]...</span>")

/datum/action/gift/falling_touch
	name = "Falling Touch"
	desc = "This Gift allows the Garou to send her foe sprawling with but a touch."
	button_icon_state = "falling_touch"
	rage_req = 1

/datum/action/gift/falling_touch/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/H = owner
		playsound(get_turf(owner), 'code/modules/wod13/sounds/falling_touch.ogg', 75, FALSE)
		H.put_in_active_hand(new /obj/item/melee/touch_attack/werewolf(H))

/datum/action/gift/inspiration
	name = "Inspiration"
	desc = "The Garou with this Gift lends new resolve and righteous anger to his brethren."
	button_icon_state = "inspiration"
	rage_req = 1

/mob/living/carbon/Life()
	. = ..()
	if(inspired)
		if(stat != DEAD)
			adjustBruteLoss(-10, TRUE)
			var/obj/effect/celerity/C = new(get_turf(src))
			C.appearance = appearance
			C.dir = dir
			var/matrix/ntransform = matrix(C.transform)
			ntransform.Scale(2, 2)
			animate(C, transform = ntransform, alpha = 0, time = 3)

/mob/living/carbon/proc/inspired()
	inspired = TRUE
	to_chat(src, "<span class='notice'>You feel inspired...</span>")
	spawn(20 SECONDS)
		to_chat(src, "<span class='warning'>You no longer feel inspired...</span>")
		inspired = FALSE

/datum/action/gift/inspiration/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/H = owner
		playsound(get_turf(owner), 'code/modules/wod13/sounds/inspiration.ogg', 75, FALSE)
		H.emote("scream")
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.adjust_veil(-1)
		for(var/mob/living/carbon/C in range(5, owner))
			if(C)
				if(iswerewolf(C) || isgarou(C))
					if(C.auspice.tribe == H.auspice.tribe)
						C.inspired()

/datum/action/gift/razor_claws
	name = "Razor Claws"
	desc = "By raking his claws over stone, steel, or another hard surface, the Ahroun hones them to razor sharpness."
	button_icon_state = "razor_claws"
	rage_req = 1

/datum/action/gift/razor_claws/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/razor_claws.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.dna.species.attack_verb = "slash"
			H.dna.species.attack_sound = 'sound/weapons/slash.ogg'
			H.dna.species.miss_sound = 'sound/weapons/slashmiss.ogg'
			H.dna.species.punchdamagelow += 5
			H.dna.species.punchdamagehigh += 5
			H.dna.species.attack_type = CLONE
			to_chat(owner, "<span class='notice'>You feel your claws sharpening...</span>")
			if(H.CheckEyewitness(H, H, 7, FALSE))
				H.adjust_veil(-1)
			spawn(20 SECONDS)
				H.dna.species.attack_verb = initial(H.dna.species.attack_verb)
				H.dna.species.attack_sound = initial(H.dna.species.attack_sound)
				H.dna.species.miss_sound = initial(H.dna.species.miss_sound)
				H.dna.species.punchdamagelow = initial(H.dna.species.punchdamagelow)
				H.dna.species.punchdamagehigh = initial(H.dna.species.punchdamagehigh)
				H.dna.species.attack_type = initial(H.dna.species.attack_type)
				to_chat(owner, "<span class='warning'>Your claws are not sharp anymore...</span>")
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/razor_claws.ogg', 75, FALSE)
			var/mob/living/carbon/H = owner
			H.melee_damage_lower = H.melee_damage_lower+5
			H.melee_damage_upper = H.melee_damage_upper+5
			to_chat(owner, "<span class='notice'>You feel your claws sharpening...</span>")
			spawn(20 SECONDS)
				H.melee_damage_lower = initial(H.melee_damage_lower)
				H.melee_damage_upper = initial(H.melee_damage_upper)
				to_chat(owner, "<span class='warning'>Your claws are not sharp anymore...</span>")

/datum/action/gift/beast_speech
	name = "Beast Speech"
	desc = "The werewolf with this Gift may communicate with any animals from fish to mammals."
	button_icon_state = "beast_speech"
	rage_req = 1
	//gnosis_req = 1

/datum/action/gift/beast_speech/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		if(length(C.beastmaster) > 3)
			var/mob/living/simple_animal/hostile/beastmaster/B = pick(C.beastmaster)
			qdel(B)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/wolves.ogg', 75, FALSE)
		if(!length(C.beastmaster))
			var/datum/action/beastmaster_stay/E1 = new()
			E1.Grant(C)
			var/datum/action/beastmaster_deaggro/E2 = new()
			E2.Grant(C)
		var/mob/living/simple_animal/hostile/beastmaster/D = new(get_turf(C))
		D.my_creator = C
		C.beastmaster |= D
		D.beastmaster = C

/datum/action/gift/call_of_the_wyld
	name = "Call Of The Wyld"
	desc = "The werewolf may send her howl far beyond the normal range of hearing and imbue it with great emotion, stirring the hearts of fellow Garou and chilling the bones of all others."
	button_icon_state = "call_of_the_wyld"
	rage_req = 1

/datum/action/gift/call_of_the_wyld/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.emote("howl")
		playsound(get_turf(C), pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 100, FALSE)
		for(var/mob/living/carbon/A in orange(6, owner))
			if(A)
				if(isgarou(A) || iswerewolf(A))
					A.emote("howl")
					playsound(get_turf(A), pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 100, FALSE)
					spawn(10)
						adjust_gnosis(1, A, TRUE)
//	awo1

/datum/action/gift/mindspeak
	name = "Mindspeak"
	desc = "By invoking the power of waking dreams, the Garou can place any chosen characters into silent communion."
	button_icon_state = "mindspeak"
//	gnosis_req = 1

/datum/action/gift/mindspeak/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/new_thought = input(owner, "What do you want to tell to your Tribe?") as text|null
		if(new_thought)
			var/mob/living/carbon/C = owner
			to_chat(C, "You transfer this message to your tribe members nearby: <b>[sanitize_text(new_thought)]</b>")
			for(var/mob/living/carbon/A in orange(9, owner))
				if(A)
					if(isgarou(A) || iswerewolf(A))
						if(A.auspice.tribe == C.auspice.tribe)
							to_chat(A, "You hear a message in your head... <b>[sanitize_text(new_thought)]</b>")

/datum/action/gift/resist_pain
	name = "Resist Pain"
	desc = "Through force of will, the Philodox is able to ignore the pain of his wounds and continue acting normally."
	button_icon_state = "resist_pain"
	rage_req = 2

/datum/action/gift/resist_pain/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/resist_pain.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.attributes.stamina_bonus += 4
			to_chat(owner, "<span class='notice'>You feel your skin thickering...</span>")
			spawn(20 SECONDS)
				H.attributes.stamina_bonus -= 4
				to_chat(owner, "<span class='warning'>Your skin is thin again...</span>")
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/resist_pain.ogg', 75, FALSE)
			var/mob/living/carbon/werewolf/H = owner
			H.werewolf_armor = 40
			to_chat(owner, "<span class='notice'>You feel your skin thickering...</span>")
			spawn(20 SECONDS)
				H.werewolf_armor = initial(H.werewolf_armor)
				to_chat(owner, "<span class='warning'>Your skin is thin again...</span>")

/datum/action/gift/scent_of_the_true_form
	name = "Scent Of The True Form"
	desc = "This Gift allows the Garou to determine the true nature of a person."
	button_icon_state = "scent_of_the_true_form"
	gnosis_req = 1

/datum/action/gift/scent_of_the_true_form/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(HAS_TRAIT(owner, TRAIT_SCENTTRUEFORM))
			REMOVE_TRAIT(owner, TRAIT_SCENTTRUEFORM, WEREWOLF_TRAIT)
			to_chat(owner, "<span class='notice'>You allow the essence of the spirit to leave your senses.</span>")

		else
			ADD_TRAIT(owner, TRAIT_SCENTTRUEFORM, WEREWOLF_TRAIT)
			to_chat(owner, "<span class='notice'>Your nose gains a clarity for the supernal around you...</span>")

/datum/action/gift/truth_of_gaia
	name = "Truth Of Gaia"
	desc = "As judges of the Litany, Philodox have the ability to sense whether others have spoken truth or falsehood."
	button_icon_state = "truth_of_gaia"
//	rage_req = 1

/datum/action/gift/truth_of_gaia/Trigger()
	. = ..()
//	if(allowed_to_proceed)
//

/datum/action/gift/mothers_touch
	name = "Mother's Touch"
	desc = "The Garou is able to heal the wounds of any living creature, aggravated or otherwise, simply by laying hands over the afflicted area."
	button_icon_state = "mothers_touch"
	rage_req = 2
	//gnosis_req = 1

/datum/action/gift/mothers_touch/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/H = owner
		H.put_in_active_hand(new /obj/item/melee/touch_attack/mothers_touch(H))

/datum/action/gift/sense_wyrm
	name = "Sense Wyrm"
	desc = "This Gift allows the werewolf to trace the location of all wyrm-tainted entities within the area."
	button_icon_state = "sense_wyrm"
	rage_req = 1

/datum/action/gift/sense_wyrm/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/list/mobs_in_range = list()
		for(var/mob/living/carbon/target in orange(owner, 30))
			mobs_in_range += target
		for(var/mob/living/carbon/target in mobs_in_range)
			var/is_wyrm = 0
			if(iscathayan(target))
				var/mob/living/carbon/human/kj = target
				if(!kj.check_kuei_jin_alive())
					is_wyrm = 1
			if (iskindred(target))
				var/mob/living/carbon/human/vampire = target
				if ((vampire.humanity < 7 || vampire.clane?.name == "Baali") && !vampire.active_blush)
					is_wyrm = 1
			if (isgarou(target) || iswerewolf(target))
				var/mob/living/carbon/wolf = target
				if(wolf.auspice.tribe.name == "Black Spiral Dancers")
					is_wyrm = 1
			if(is_wyrm)
				to_chat(owner, "A stain is found at [get_area_name(target)], X:[target.x] Y:[target.y].")
				is_wyrm = 0

/datum/action/gift/spirit_speech
	name = "Spirit Speech"
	desc = "This Gift allows the Garou to communicate with encountered spirits."
	button_icon_state = "spirit_speech"
	//gnosis_req = 1

/datum/action/gift/spirit_speech/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/datum/atom_hud/ghost_hud = GLOB.huds[DATA_HUD_GHOST]
		ghost_hud.add_hud_to(owner)
		to_chat(owner, span_notice("You open your senses to the spirit world."))
		spawn(20 SECONDS)
			ghost_hud.remove_hud_from(owner)
			to_chat(owner, span_warning("Your connection to the spirit world fades."))

/datum/action/gift/blur_of_the_milky_eye
	name = "Blur Of The Milky Eye"
	desc = "The Garou's form becomes a shimmering blur, allowing him to pass unnoticed among others."
	button_icon_state = "blur_of_the_milky_eye"
	rage_req = 2
	//gnosis_req = 1

/datum/action/gift/blur_of_the_milky_eye/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.obfuscate_level = clamp(C.client.prefs.auspice_level*2, 1, 5)
		C.alpha = 100
		C.invisibility = INVISIBILITY_LEVEL_OBFUSCATE+clamp(C.client.prefs.auspice_level*2, 1, 5)
		owner.playsound_local(get_turf(owner), 'code/modules/wod13/sounds/milky_blur.ogg', 75, FALSE)
		spawn(20 SECONDS)
			C.obfuscate_level = 0
			C.alpha = 255
			C.invisibility = initial(C.invisibility)

/datum/action/gift/open_seal
	name = "Open Seal"
	desc = "With this Gift, the Garou can open nearly any sort of closed or locked physical device."
	button_icon_state = "open_seal"
//	gnosis_req = 1

/datum/action/gift/open_seal/Trigger()
	. = ..()
	if(allowed_to_proceed)
		for(var/obj/structure/vampdoor/V in range(5, owner))
			if(V)
				if(V.closed)
					if(V.lockpick_difficulty < clamp(10*owner.client.prefs.auspice_level, 10, 30))
						V.locked = FALSE
						playsound(V, V.open_sound, 75, TRUE)
						V.icon_state = "[V.baseicon]-0"
						V.density = FALSE
						V.opacity = FALSE
						V.layer = OPEN_DOOR_LAYER
						to_chat(owner, "<span class='notice'>You open [V].</span>")
						V.closed = FALSE

/datum/action/gift/infectious_laughter
	name = "Infectious Laughter"
	desc = "When the Ragabash laughs, those around her are compelled to follow along, forgetting their grievances."
	button_icon_state = "infectious_laughter"
	rage_req = 1

/datum/action/gift/infectious_laughter/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.emote("laugh")
		C.Stun(10)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/infectious_laughter.ogg', 100, FALSE)
		for(var/mob/living/L in oviewers(4, owner))
			if(L)
				L.emote("laugh")
				L.Stun(20)

/datum/action/gift/rage_heal
	name = "Rage Heal"
	desc = "This Gift allows the Garou to heal severe injuries with rage."
	button_icon_state = "rage_heal"
	rage_req = 1
	check_flags = null

/datum/action/gift/rage_heal/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		if(C.stat != DEAD)
			SEND_SOUND(owner, sound('code/modules/wod13/sounds/rage_heal.ogg', 0, 0, 75))
			C.adjustBruteLoss(-30*C.auspice.level, TRUE)
			C.adjustFireLoss(-30*C.auspice.level, TRUE)
			C.adjustCloneLoss(-15*C.auspice.level, TRUE)
			C.adjustToxLoss(-15*C.auspice.level, TRUE)
			C.adjustOxyLoss(-25*C.auspice.level, TRUE)
			C.bloodpool = min(C.bloodpool + C.auspice.level, C.maxbloodpool)
			C.blood_volume = min(C.blood_volume + 56 * C.auspice.level, BLOOD_VOLUME_NORMAL)
			if(ishuman(owner))
				var/mob/living/carbon/human/BD = owner
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()

/datum/action/change_apparel
	name = "Change Apparel"
	desc = "Choose the clothes of your Crinos form."
	button_icon_state = "choose_apparel"
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS

/datum/action/change_apparel/Trigger()
	. = ..()
	var/mob/living/carbon/werewolf/crinos/C = owner
	if(C.stat == CONSCIOUS)
		if(C.sprite_apparel == 4)
			C.sprite_apparel = 0
		else
			C.sprite_apparel = min(4, C.sprite_apparel+1)

/datum/action/gift/hispo
	name = "Hispo Form"
	desc = "Change your Lupus form into Hispo and backwards."
	button_icon_state = "hispo"

/datum/action/gift/hispo/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/werewolf/lupus/H = owner
		playsound(get_turf(owner), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
		var/matrix/ntransform = matrix(owner.transform)
		if(H.hispo)
			ntransform.Scale(0.95, 0.95)
			animate(owner, transform = ntransform, color = "#000000", time = DOGGY_ANIMATION_COOLDOWN)
			addtimer(CALLBACK(src, PROC_REF(transform_lupus), H), DOGGY_ANIMATION_COOLDOWN)
		else
			ntransform.Scale(1.05, 1.05)
			animate(owner, transform = ntransform, color = "#000000", time = DOGGY_ANIMATION_COOLDOWN)
			addtimer(CALLBACK(src, PROC_REF(transform_hispo), H), DOGGY_ANIMATION_COOLDOWN)

/datum/action/gift/hispo/proc/transform_lupus(mob/living/carbon/werewolf/lupus/H)
	if(HAS_TRAIT(H, TRAIT_DOGWOLF))
		H.icon = 'code/modules/wod13/werewolf_lupus.dmi'
	else
		H.icon = 'code/modules/wod13/vtm_lupus.dmi'
	H.pixel_w = 0
	H.pixel_z = 0
	H.melee_damage_lower = initial(H.melee_damage_lower)
	H.melee_damage_upper = initial(H.melee_damage_upper)
	H.armour_penetration = initial(H.armour_penetration)
	H.hispo = FALSE
	H.attributes.strength -= 3
	H.attributes.dexterity -= 2
	H.attributes.stamina -= 3
	H.attributes.manipulation += 3
	H.regenerate_icons()
	H.update_transform()
	animate(H, transform = null, color = "#FFFFFF", time = 1)
	H.remove_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	H.add_movespeed_modifier(/datum/movespeed_modifier/lupusform)

/datum/action/gift/hispo/proc/transform_hispo(mob/living/carbon/werewolf/lupus/H)
	H.icon = 'code/modules/wod13/hispo.dmi'
	H.pixel_w = -16
	H.pixel_z = -16
	H.melee_damage_lower = 30
	H.melee_damage_upper = 30
	H.armour_penetration = 35
	H.hispo = TRUE
	H.attributes.strength += 3
	H.attributes.dexterity += 2
	H.attributes.stamina += 3
	H.attributes.manipulation -= 3
	H.regenerate_icons()
	H.update_transform()
	animate(H, transform = null, color = "#FFFFFF", time = 1)
	H.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
	H.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)

/datum/movespeed_modifier/hispoform
	multiplicative_slowdown = -0.5

/datum/action/gift/glabro
	name = "Glabro Form"
	desc = "Change your Homid form into Glabro and backwards."
	button_icon_state = "glabro"

/datum/action/gift/glabro/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/human/H = owner
		var/datum/species/garou/G = H.dna.species
		if(!HAS_TRAIT(owner, TRAIT_CORAX))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
		if(G.glabro)
			H.remove_overlay(PROTEAN_LAYER)
			H.melee_damage_lower = initial(H.melee_damage_lower)
			H.melee_damage_upper = initial(H.melee_damage_upper)
			H.armour_penetration = initial(H.armour_penetration)
			H.dna.species.attack_type = initial(H.dna.species.attack_type)
			H.dna.species.attack_verb = initial(H.dna.species.attack_verb)
			H.dna.species.attack_sound = initial(H.dna.species.attack_sound)
			H.dna.species.miss_sound = initial(H.dna.species.miss_sound)
			H.limb_destroyer = initial(H.limb_destroyer)
			H.attributes.strength -= 2
			H.attributes.stamina -= 2
			H.attributes.appearance += 1
			H.attributes.manipulation += 1
			var/matrix/M = matrix()
			M.Scale(1)
			animate(H, transform = M, time = 1 SECONDS)
			G.glabro = FALSE
			H.update_icons()
		else
			if(HAS_TRAIT(owner, TRAIT_CORAX))
				to_chat(owner,"<span class='warning'>Corax do not have a Glabro form to shift into.</span>")
				return
			else
				H.remove_overlay(PROTEAN_LAYER)
				var/mob/living/carbon/werewolf/crinos/crinos = H.transformator.crinos_form?.resolve()
				var/mutable_appearance/glabro_overlay = mutable_appearance('code/modules/wod13/werewolf_abilities.dmi', crinos?.sprite_color, -PROTEAN_LAYER)
				H.overlays_standing[PROTEAN_LAYER] = glabro_overlay
				H.apply_overlay(PROTEAN_LAYER)
				H.melee_damage_lower = 30
				H.melee_damage_upper = 30
				H.armour_penetration = 35
				H.dna.species.attack_type = CLONE
				H.dna.species.attack_verb = "slash"
				H.dna.species.attack_sound = 'sound/weapons/slash.ogg'
				H.dna.species.miss_sound = 'sound/weapons/slashmiss.ogg'
				H.limb_destroyer = 1
				H.attributes.strength += 2
				H.attributes.stamina += 2
				H.attributes.appearance -= 1
				H.attributes.manipulation -= 1
				var/matrix/M = matrix()
				M.Scale(1.23)
				animate(H, transform = M, time = 1 SECONDS)
				G.glabro = TRUE
				H.update_icons()

/datum/action/gift/howling
	name = "Howl"
	desc = "The werewolf may send her howl far beyond the normal range of hearing and communicate a single word or concept to all other Garou across the city."
	button_icon_state = "call_of_the_wyld"
	rage_req = 1
	cool_down = 5
	check_flags = null
	var/list/howls = list(
		"attack" = list(
			"menu" = "Attack",
			"message" = "<b>A wolf howls a fierce call to attack</b>",
			"corax_message" = "<b>A raven hisses a fierce call to attack</b>"
		),
		"retreat" = list(
			"menu" = "Retreat",
			"message" = "<b>A wolf howls a warning to retreat</b>",
			"corax_message" = "<b>A raven squawks a warning to retreat</b>"
		),
		"help" = list(
			"menu" = "Help",
			"message" = "<b>A wolf howls a desperate plea for help</b>",
			"corax_message" = "<b>A raven shrieks a a desperate plea for help</b>"
		),
		"gather" = list(
			"menu" = "Gather",
			"message" = "<b>A wolf howls to gather the pack</b>",
			"corax_message" = "<b>A raven beckons the conspiracy</b>"
		),
		"victory" = list(
			"menu" = "Victory",
			"message" = "<b>A wolf howls in celebration of victory</b>",
			"corax_message" = "<b>A raven croaks in celebration of victory</b>"
		),
		"dying" = list(
			"menu" = "Dying",
			"message" = "<b>A wolf howls in pain and despair</b>",
			"corax_message" = "<b>A raven shrieks in pain and despair</b>"
		),
		"mourning" = list(
			"menu" = "Mourning",
			"message" = "<b>A wolf howls in deep mourning for the fallen</b>",
			"corax_message" = "<b>A raven mourns the loss of the fallen</b>"
		)
	)

/datum/action/gift/howling/Trigger()
	. = ..()
	if(allowed_to_proceed)

		if(istype(get_area(owner), /area/vtm/interior/penumbra))
			to_chat(owner, span_warning("Your howl echoes and dissipates into the Umbra, it's sound blanketed by the spiritual energy of the Velvet Shadow."))
			return

		var/mob/living/carbon/C = owner
		var/list/menu_options = list()
		for (var/howl_key in howls)
			menu_options += howls[howl_key]["menu"]
		menu_options += "Cancel"

		var/choice = tgui_input_list(owner, "Select a howl to use!", "Howl Selection", menu_options)
		if(choice && choice != "Cancel")
			var/howl
			for (var/howl_key in howls)
				if (howls[howl_key]["menu"] == choice)
					howl = howls[howl_key]
					break

			var/message = howl[(HAS_TRAIT(C, TRAIT_CORAX)) ? "corax_message" : "message" ]
			var/tribe = C.auspice.tribe.name
			if (tribe)
				message = replacetext(message, "tribe", tribe)

			var/origin_turf = get_turf(C)

			if(!HAS_TRAIT(C, TRAIT_CORAX))
				C.emote("howl")
				playsound(origin_turf, pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 50, FALSE)
			else
				C.emote("caw")
				playsound(origin_turf, 'code/modules/wod13/sounds/cawcorvid.ogg', 50, FALSE)

			var/list/sound_hearers = list()

			for(var/mob/living/carbon/HearingGarou in range(17))
				if(isgarou(HearingGarou) || iswerewolf(HearingGarou))
					sound_hearers += HearingGarou

			var/howl_details
			var/final_message
			for(var/mob/living/carbon/Garou in GLOB.player_list)
				if((isgarou(Garou) || iswerewolf(Garou) || HAS_TRAIT(Garou, TRAIT_CORAX)) && Garou != owner)
					if(!sound_hearers.Find(Garou))
						if(!HAS_TRAIT(C, TRAIT_CORAX))
							Garou.playsound_local(get_turf(Garou), pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 25, FALSE)
						else
							Garou.playsound_local(get_turf(Garou), 'code/modules/wod13/sounds/cawcorvid.ogg', 25, FALSE)
					howl_details = get_message(Garou, origin_turf)
					final_message = message + howl_details
					to_chat(Garou, final_message, confidential = TRUE)


/datum/action/gift/howling/proc/get_message(mob/living/carbon/Garou, turf/origin_turf)

	var/distance = get_dist(Garou, origin_turf)
	var/dirtext = "to the "
	var/direction = get_dir(Garou, origin_turf)

	switch(direction)
		if(NORTH)
			dirtext += "north"
		if(SOUTH)
			dirtext += "south"
		if(EAST)
			dirtext += "east"
		if(WEST)
			dirtext += "west"
		if(NORTHWEST)
			dirtext += "northwest"
		if(NORTHEAST)
			dirtext += "northeast"
		if(SOUTHWEST)
			dirtext += "southwest"
		if(SOUTHEAST)
			dirtext += "southeast"
		else //Where ARE you.
			dirtext = "although I cannot make out an exact direction"

	var/disttext
	switch(distance)
		if(0 to 20)
			disttext = " within 20 feet"
		if(20 to 40)
			disttext = " 20 to 40 feet away"
		if(40 to 80)
			disttext = " 40 to 80 feet away"
		if(80 to 160)
			disttext = " far"
		else
			disttext = " very far"

	var/place = get_area_name(origin_turf)

	var/returntext = "<b>[disttext], [dirtext], at [place].</b>"

	return returntext

/datum/action/gift/stoic_pose
	name = "Stoic Pose"
	desc = "With this gift garou sends theirself into cryo-state, ignoring all incoming damage but also covering themself in a block of ice."
	button_icon_state = "stoic_pose"
	rage_req = 2
	gnosis_req = 2
	var/in_use = FALSE

/datum/action/gift/stoic_pose/Trigger()
	. = ..()
	if(!allowed_to_proceed)
		return

	playsound(get_turf(owner), 'code/modules/wod13/sounds/ice_blocking.ogg', 100, FALSE)
	var/mob/living/carbon/C = owner
	var/obj/W

	if(in_use)
		in_use = FALSE
		C.forceMove(get_turf(W))
		qdel(W)

	if(isgarou(C))
		W = new /obj/were_ice(get_turf(owner))
	if(iscrinos(C))
		W = new /obj/were_ice/crinos(get_turf(owner))
	if(islupus(C))
		W = new /obj/were_ice/lupus(get_turf(owner))

	C.Stun(300 SECONDS)
	C.forceMove(W)
	in_use = TRUE
	spawn(300 SECONDS)
		C.forceMove(get_turf(W))
		qdel(W)
		in_use = FALSE


/datum/action/gift/freezing_wind
	name = "Freezing Wind"
	desc = "Garou of Wendigo Tribe can create a stream of cold, freezing wind, and strike her foes with it."
	button_icon_state = "freezing_wind"
	rage_req = 1
	//gnosis_req = 1

/datum/action/gift/freezing_wind/Trigger()
	. = ..()
	if(allowed_to_proceed)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/wind_cast.ogg', 100, FALSE)
		for(var/turf/T in range(3, get_step(get_step(owner, owner.dir), owner.dir)))
			if(owner.loc != T)
				var/obj/effect/wind/W = new(T)
				W.dir = owner.dir
				W.strength = 100
				spawn(20 SECONDS)
					qdel(W)
//	if(allowed_to_proceed)

/datum/action/gift/bloody_feast
	name = "Bloody Feast"
	desc = "By eating a grabbed corpse, garou can redeem their lost health and heal the injuries."
	button_icon_state = "bloody_feast"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/bloody_feast/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		if(C.pulling)
			if(isliving(C.pulling))
				var/mob/living/L = C.pulling
				if(L.stat == DEAD)
					playsound(get_turf(owner), 'code/modules/wod13/sounds/bloody_feast.ogg', 50, FALSE)
					qdel(L)
					C.revive(full_heal = TRUE, admin_revive = TRUE)

/datum/action/gift/stinky_fur
	name = "Stinky Fur"
	desc = "Garou creates an aura of very toxic smell, which disorientates everyone around."
	button_icon_state = "stinky_fur"

/datum/action/gift/stinky_fur/Trigger()
	. = ..()
	if(allowed_to_proceed)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/necromancy.ogg', 75, FALSE)
		for(var/mob/living/carbon/C in orange(5, owner))
			if(C)
				if(prob(25))
					C.vomit()
				C.dizziness += 10
				C.add_confusion(10)

/datum/action/gift/venom_claws
	name = "Venom Claws"
	desc = "While this ability is active, strikes with claws poison foes of garou."
	button_icon_state = "venom_claws"
	rage_req = 1

/datum/action/gift/venom_claws/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/venom_claws.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.dna.species.attack_verb = "slash"
			H.dna.species.attack_sound = 'sound/weapons/slash.ogg'
			H.dna.species.miss_sound = 'sound/weapons/slashmiss.ogg'
			H.dna.species.punchdamagelow += 5
			H.dna.species.punchdamagehigh += 5
			H.dna.species.attack_type = CLONE
			H.tox_damage_plus = 15
			H.stam_damage_plus = 35
			to_chat(owner, span_notice("You feel your claws filling with pure venom..."))
			spawn(20 SECONDS)
				H.tox_damage_plus = 0
				H.stam_damage_plus = 0
				H.melee_damage_lower = initial(H.melee_damage_lower)
				H.melee_damage_upper = initial(H.melee_damage_upper)
				H.dna.species.attack_verb = initial(H.dna.species.attack_verb)
				H.dna.species.attack_sound = initial(H.dna.species.attack_sound)
				H.dna.species.miss_sound = initial(H.dna.species.miss_sound)
				H.dna.species.attack_type = initial(H.dna.species.attack_type)
				to_chat(owner, span_warning("Your claws are not poison anymore..."))
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/venom_claws.ogg', 75, FALSE)
			var/mob/living/carbon/H = owner
			H.dna.species.attack_verb = "slash"
			H.dna.species.attack_sound = 'sound/weapons/slash.ogg'
			H.dna.species.miss_sound = 'sound/weapons/slashmiss.ogg'
			H.dna.species.punchdamagelow += 5
			H.dna.species.punchdamagehigh += 5
			H.dna.species.attack_type = CLONE
			H.tox_damage_plus = 15
			H.stam_damage_plus = 35
			to_chat(owner, span_notice("You feel your claws filling with pure venom..."))
			spawn(20 SECONDS)
				H.tox_damage_plus = 0
				H.stam_damage_plus = 0
				H.melee_damage_lower = initial(H.melee_damage_lower)
				H.melee_damage_upper = initial(H.melee_damage_upper)
				H.dna.species.attack_verb = initial(H.dna.species.attack_verb)
				H.dna.species.attack_sound = initial(H.dna.species.attack_sound)
				H.dna.species.miss_sound = initial(H.dna.species.miss_sound)
				H.dna.species.attack_type = initial(H.dna.species.attack_type)
				to_chat(owner, span_warning("Your claws are not poison anymore..."))

/datum/action/gift/burning_scars
	name = "Burning Scars"
	desc = "Garou creates an aura of very hot air, which burns everyone around."
	button_icon_state = "burning_scars"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/burning_scars/Trigger()
	. = ..()
	if(allowed_to_proceed)
		owner.visible_message(span_userdanger("[owner.name] crackles with heat!</span>"), span_warning("You crackle with heat, charging up your Gift!"))
		playsound(owner, 'sound/magic/burning_scars.ogg', 100, TRUE, extrarange = 5)
		owner.move_resist = MOVE_FORCE_STRONG
		if(do_after(owner, 1.5 SECONDS))
			owner.move_resist = initial(owner.move_resist)
			for(var/mob/living/L in orange(5, owner))
				if(L)
					L.adjustFireLoss(40)
			for(var/turf/T in orange(4, get_turf(owner)))
				var/obj/effect/fire/F = new(T)
				spawn(6)
					qdel(F)
		else
			owner.move_resist = initial(owner.move_resist)

/datum/action/gift/smooth_move
	name = "Smooth Move"
	desc = "Garou jumps forward, avoiding every damage for a moment."
	button_icon_state = "smooth_move"
	//rage_req = 1   somewhat useless gift with MMB pounce

/datum/action/gift/smooth_move/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/turf/T = get_turf(get_step(get_step(get_step(owner, owner.dir), owner.dir), owner.dir))
		if(!T || T == owner.loc)
			return
		owner.visible_message(span_danger("[owner] charges!"))
		owner.setDir(get_dir(owner, T))
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(owner.loc,owner)
		animate(D, alpha = 0, color = "#FF0000", transform = matrix()*2, time = 1)
		spawn(3)
			owner.throw_at(T, get_dist(owner, T), 1, owner, 0)

/datum/action/gift/digital_feelings
	name = "Digital Feelings"
	desc = "Every technology creates an electrical strike, which hits garou's enemies."
	button_icon_state = "digital_feelings"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/digital_feelings/Trigger()
	. = ..()
	if(allowed_to_proceed)
		owner.visible_message(span_danger("[owner.name] crackles with static electricity!"), span_danger("You crackle with static electricity, charging up your Gift!"))
		playsound(owner, 'sound/magic/digital_feelings.ogg', 100, TRUE, extrarange = 5)
		owner.move_resist = MOVE_FORCE_STRONG
		if(do_after(owner, 1.5 SECONDS))
			owner.move_resist = initial(owner.move_resist)
			playsound(owner, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
			tesla_zap(owner, 3, 30, ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_MOB_STUN | ZAP_ALLOW_DUPLICATES)
			for(var/mob/living/L in orange(6, owner))
				if(L)
					L.electrocute_act(30, owner, siemens_coeff = 1, flags = NONE)
		else
			owner.move_resist = initial(owner.move_resist)

/datum/action/gift/hands_full_of_thunder
	name = "Hands Full of Thunder"
	desc = "Invoke the machine spirits to support you in these trying times. Abstain from needing bullets when you fire a gun."
	button_icon_state = "hands_full_of_thunder"
	gnosis_req = 1

/datum/action/gift/hands_full_of_thunder/Trigger()
	. = ..()
	if(allowed_to_proceed)
		ADD_TRAIT(owner, TRAIT_THUNDERSHOT, WEREWOLF_TRAIT)
		to_chat(owner, span_notice("You feel your fingers tingling with electricity...!"))
		spawn(10 SECONDS)
			REMOVE_TRAIT(owner, TRAIT_THUNDERSHOT, WEREWOLF_TRAIT)
			to_chat(owner, span_notice("The buzz in your fingertips ebbs..."))

/datum/action/gift/elemental_improvement
	name = "Elemental Improvement"
	desc = "Garou flesh replaces itself with prothesis, making it less vulnerable to brute damage, but more for burn damage."
	button_icon_state = "elemental_improvement"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/elemental_improvement/Trigger()
	. = ..()
	if(allowed_to_proceed)
		animate(owner, color = "#6a839a", time = 10)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/electro_cast.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.attributes.stamina_bonus += 4
			H.attributes.dexterity_bonus += 2
			to_chat(owner, span_notice("You feel your skin replaced with the machine..."))
			spawn(20 SECONDS)
				H.attributes.stamina_bonus -= 4
				H.attributes.dexterity_bonus -= 2
				to_chat(owner, span_warning("Your skin is natural again..."))
				owner.color = "#FFFFFF"
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/electro_cast.ogg', 75, FALSE)
			var/mob/living/carbon/werewolf/H = owner
			H.werewolf_armor = 45
			to_chat(owner, span_notice("You feel your skin replaced with the machine..."))
			spawn(20 SECONDS)
				H.werewolf_armor = initial(H.werewolf_armor)
				to_chat(owner, span_warning("Your skin is natural again..."))
				owner.color = "#FFFFFF"

/datum/action/gift/guise_of_the_hound
	name = "Guise of the Hound"
	desc = "Wear the skin of the fleabitten dog to pass without concern."
	button_icon_state = "guise_of_the_hound"
	rage_req = 1

/datum/action/gift/guise_of_the_hound/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(!HAS_TRAIT(owner,TRAIT_DOGWOLF))
			ADD_TRAIT(owner, TRAIT_DOGWOLF, WEREWOLF_TRAIT)
			to_chat(owner, span_notice("You feel your canid nature softening!"))
		else
			REMOVE_TRAIT(owner, TRAIT_DOGWOLF, WEREWOLF_TRAIT)
			to_chat(owner, span_notice("You feel your lupine nature intensifying!"))

		if(istype(owner, /mob/living/carbon/werewolf/lupus))
			var/mob/living/carbon/werewolf/lupus/lopor = owner

			if(lopor && !lopor.hispo)
				playsound(get_turf(owner), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
				var/matrix/ntransform = matrix(owner.transform)
				ntransform.Scale(0.95, 0.95)
				animate(owner, transform = ntransform, color = "#000000", time = 3 SECONDS)
				addtimer(CALLBACK(src, PROC_REF(transform_lupus), lopor), 3 SECONDS)

/datum/action/gift/guise_of_the_hound/proc/transform_lupus(mob/living/carbon/werewolf/lupus/H)
	if(HAS_TRAIT(H, TRAIT_DOGWOLF))
		H.icon = 'code/modules/wod13/werewolf_lupus.dmi'
	else
		H.icon = 'code/modules/wod13/vtm_lupus.dmi'
	H.regenerate_icons()
	H.update_transform()
	animate(H, transform = null, color = "#FFFFFF", time = 1)

/datum/action/gift/infest
	name = "Infest"
	desc = "Call forth the vermin in the area to serve you against your enemies."
	button_icon_state = "infest"
	rage_req = 1

/datum/action/gift/infest/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(iscarbon(owner))
			var/mob/living/carbon/C = owner
			if(length(C.beastmaster) > get_a_intelligence(C)+get_a_occult(C))
				var/mob/living/simple_animal/hostile/beastmaster/beast = pick(C.beastmaster)
				beast.death()
			if(!length(C.beastmaster))
				var/datum/action/beastmaster_stay/stay = new()
				stay.Grant(C)
				var/datum/action/beastmaster_deaggro/deaggro = new()
				deaggro.Grant(C)

			var/mob/living/simple_animal/hostile/beastmaster/cockroach/roach = new(get_turf(C))
			roach.my_creator = C
			C.beastmaster |= roach
			roach.beastmaster = C

/mob/living/simple_animal/hostile/beastmaster/cockroach
	name = "cockroach"
	desc = "It flutters like the giant, unhealthy skittering thing it is."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "cockroach"
	icon_living = "cockroach"
	icon_dead = "cockroach_no_animation"
	emote_hear = list("chitters.")
	emote_see = list("flutters its' wings.", "wriggles its' antennae.")
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_chance = 0
	turns_per_move = 5
	see_in_dark = 10
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently sweeps aside"
	response_disarm_simple = "gently sweep aside"
	response_harm_continuous = "smashes"
	response_harm_simple = "smash"
	can_be_held = FALSE
	density = FALSE
	anchored = FALSE
	footstep_type = FOOTSTEP_MOB_CLAW
	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 1
	maxbloodpool = 1
	del_on_death = 1
	maxHealth = 5
	health = 5
	melee_damage_type = TOX
	harm_intent_damage = 7
	melee_damage_lower = 7
	melee_damage_upper = 7
	is_flying_animal = TRUE
	speed = -0.8
	dodging = TRUE

/datum/action/gift/gift_of_the_termite
	name = "Gift of the Termite"
	desc = "Eat through structures. Obey no laws but the litany."
	button_icon_state = "gift_of_the_termite"
	rage_req = 3
	gnosis_req = 2

/datum/action/gift/gift_of_the_termite/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/H = owner
		H.put_in_active_hand(new /obj/item/melee/touch_attack/werewolf/gift_of_the_termite(H))


/datum/action/gift/shroud
	name = "Shroud"
	desc = "Call together the shadows, blocking line of sight."
	button_icon_state = "shroud"
	rage_req = 1

/datum/action/gift/shroud/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/atom/movable/shadow
		shadow = new(owner)
		shadow.set_light(5, -10)
		spawn(20 SECONDS)
			if (shadow)
				QDEL_NULL(shadow)

/datum/action/gift/coils_of_the_serpent
	name = "Coils of the Serpent"
	desc = "Summon forth tendrils of shadow to assault an opponent."
	button_icon_state = "coils_of_the_serpent"
	rage_req = 1

/datum/action/gift/coils_of_the_serpent/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			if(H.CheckEyewitness(H, H, 7, FALSE))
				H.adjust_veil(-1)
			H.drop_all_held_items()
			H.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel/lasombra(owner))
			H.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel/lasombra(owner))
			for(var/obj/item/melee/vampirearms/knife/gangrel/lasombra/arm in H.contents)
				arm.name = "\improper shadow coil"
				arm.desc = "Squeeze tight."
				spawn(20 SECONDS)
					qdel(arm)

/datum/action/gift/banish_totem
	name = "Banish Totem"
	desc = "Choose a target. Dissolve the gnosis and connection they hold temporarily to their totem."
	button_icon_state = "banish_totem"
	rage_req = 3
	gnosis_req = 2

/datum/action/gift/banish_totem/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/valid_tribe = FALSE
		var/list/targets = list()
		for(var/mob/living/carbon/werewolf/wtarget in orange(7,owner))
			targets += wtarget
		for(var/mob/living/carbon/human/htarget in orange(7,owner))
			targets += htarget
		var/mob/living/carbon/target = tgui_input_list(owner, "Select a target", "Banish Totem", sort_list(targets))
		if(target && (iswerewolf(target) || isgarou(target)))
			valid_tribe = target.auspice.tribe
		for(var/mob/living/carbon/targetted in targets)
			if(targetted && targetted.auspice.tribe.name == valid_tribe)
				targetted.auspice.gnosis = 0
				to_chat(targetted, span_userdanger("You feel your tie to your totem snap, gnosis leaving you...!"))
				to_chat(owner, span_danger("You feel [target.name]'s gnostic ties fray...!"))

/datum/action/gift/suns_guard // MASSIVE thanks to MachinePixie for coding this and the eye-drinking gifts, as well as making the relevant sprites
	name = "Sun's Guard"
	desc = "Gain the blessing of Helios, and become immune to spark and inferno both"
	button_icon_state = "sunblock"
	rage_req = 2
	cool_down = 21 SECONDS




/datum/action/gift/suns_guard/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/caster = owner
		var/storeburnmod = caster.dna.species.burnmod
		caster.dna.species.burnmod = 0
		caster.set_fire_stacks(0)
		ADD_TRAIT(caster, TRAIT_RESISTHEAT, MAGIC_TRAIT)
		animate(caster, color = "#ff8800", time = 10, loop = 1)
		playsound(get_turf(caster), 'code/modules/wod13/sounds/resist_pain.ogg', 75, FALSE)
		to_chat(caster, "Sun's Guard activated, you have become immune to fire.")
		addtimer(CALLBACK(src, PROC_REF(end_guard)), 140, storeburnmod)


/datum/action/gift/suns_guard/proc/end_guard(storedburnmodifier)
	var/mob/living/carbon/caster = owner
	caster.dna.species.burnmod = storedburnmodifier
	caster.set_fire_stacks(0)
	REMOVE_TRAIT(caster, TRAIT_RESISTHEAT, MAGIC_TRAIT)
	caster.color = initial(caster.color)
	playsound(get_turf(caster), 'code/modules/wod13/sounds/resist_pain.ogg', 75, FALSE)
	to_chat(caster, "Sun's Guard is no longer active, you are no longer immune to fire.")

/datum/action/gift/eye_drink
	name = "Eye-Drinking"
	desc = "Consumes the eyes of a corpse to unlock the secrets of its demise. Will risk breaching the veil if used in homid."
	button_icon_state = "eye_drink"
	rage_req = 0
	cool_down = 1 MINUTES

/datum/action/gift/eye_drink/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/caster = owner
		if(caster.pulling)
			var/mob/living/carbon/victim = caster.pulling
			var/obj/item/organ/eyes/victim_eyeballs = victim.getorganslot(ORGAN_SLOT_EYES)
			var/isNPC = TRUE
			if(!iscarbon(victim) || victim.stat != DEAD )
				to_chat(caster, "<span class='warning'>You aren't currently pulling a corpse!</span>")
				return
			else
				if(!victim_eyeballs)
					to_chat(caster, "<span class='warning'>You cannot drink the eyes of a corpse that has no eyes!</span>")
					return
				else
					if (!do_after(caster, 3 SECONDS)) //timer to cast
						return
					var/permission = tgui_input_list(victim, "Will you allow [caster.real_name] to view your death? (Note: You are expected to tell the truth in your character's eyes!)", "Select", list("Yes","No","I don't recall") ,"Yes", 1 MINUTES)
					var/victim_two = victim

					if (!permission) //returns null if no soul in body
						for (var/mob/dead/observer/ghost in GLOB.player_list)
							if (ghost.mind == victim.last_mind)
								//ask again if null
								permission = tgui_input_list(ghost, "Will you allow [caster.real_name] to view your death? (Note: You are expected to tell the truth in your character's eyes!)", "Select", list("Yes","No","I don't recall") ,"Yes", 1 MINUTES)
								victim_two = ghost
								break //no need to do further iterations if you found the right person

					if(permission == "Yes")
						if(ishuman(caster)) //listen buddy, hulking ravenmen and ravens can eat those eyes just fine, but a human? DISGUSTING.
							if(caster.CheckEyewitness(caster, caster, 7, FALSE))
								caster.adjust_veil(-1)
						playsound(get_turf(owner), 'sound/items/eatfood.ogg', 50, FALSE) //itadakimasu! :D
						qdel(victim_eyeballs)
						caster.adjust_nutrition(5) //organ nutriment value is 5
						to_chat(caster, "You drink of the eyes of [victim.name] and a vision fills your mind...")
						var/deathdesc = tgui_input_text(victim_two, "", "How did you die?", "", 300, TRUE, TRUE, 5 MINUTES)
						if (deathdesc == "")
							to_chat(caster, "The vision is hazy, you can't make out many details...")
						else
							to_chat(caster, "<i>[deathdesc]</i>")
						//discount scanner
						to_chat(caster,"<b>Damage taken:<b><br>BRUTE: [victim.getBruteLoss()]<br>OXY: [victim.getOxyLoss()]<br>TOXIN: [victim.getToxLoss()]<br>BURN: [victim.getFireLoss()]<br>CLONE: [victim.getCloneLoss()]")
						to_chat(caster, "Last melee attacker: [victim.lastattacker]") //guns behave weirdly
						isNPC = FALSE

					else if(permission == "No")
						to_chat(caster,"<span class='warning'>The spirit seems relunctact to let you consume their eyes... so you refrain from doing so.</span>")
						isNPC = FALSE

					if(isNPC)
						playsound(get_turf(owner), 'sound/items/eatfood.ogg', 50, FALSE) //yummers
						qdel(victim_eyeballs)
						caster.adjust_nutrition(5) //organ nutriment value is 5
						to_chat(caster, "You drink of the eyes of [victim.name] but no vision springs to mind...")
						to_chat(caster,"<b>Damage taken:<b><br>BRUTE: [victim.getBruteLoss()]<br>OXY: [victim.getOxyLoss()]<br>TOXIN: [victim.getToxLoss()]<br>BURN: [victim.getFireLoss()]<br>CLONE: [victim.getCloneLoss()]")
						to_chat(caster, "Last melee attacker: [victim.lastattacker]") //guns behave weirdly


GLOBAL_LIST_INIT(step_sideways_z_pairs, list(
	"2" = 6,
	"3" = 7,
	"4" = 8,
	"5" = 9,
	"6" = 2,
	"7" = 3,
	"8" = 4,
	"9" = 5,
))

GLOBAL_LIST_INIT(step_sideways_earth_zlevels, list(2, 3, 4, 5))
GLOBAL_LIST_INIT(step_sideways_penumbra_zlevels, list(6, 7, 8, 9))
GLOBAL_LIST_INIT(step_sideways_deep_umbra_zlevels, list(10))

/proc/get_paired_zlevel(z)
	var/key = "[z]"
	if(key in GLOB.step_sideways_z_pairs)
		return GLOB.step_sideways_z_pairs[key]
	return 0

/proc/is_penumbra_zlevel(z)
	return (z in GLOB.step_sideways_penumbra_zlevels)

/proc/is_earth_zlevel(z)
	return (z in GLOB.step_sideways_earth_zlevels)

/proc/is_deep_umbra_zlevel(z)
	return (z in GLOB.step_sideways_deep_umbra_zlevels)

/proc/is_umbra_realm_zlevel(z)
	return is_penumbra_zlevel(z) || is_deep_umbra_zlevel(z)

/datum/action/gift/step_sideways
	name = "Step Sideways"
	desc = "Cross the Gauntlet that separates the physical world from the Penumbra."
	button_icon_state = "step_sideways"
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS
	rage_req = 0
	gnosis_req = 0
	var/casting = FALSE
	var/step_cooldown = 15 SECONDS
	COOLDOWN_DECLARE(step_cd)

/datum/action/gift/step_sideways/Trigger()
	if(!COOLDOWN_FINISHED(src, step_cd))
		to_chat(owner, span_warning("You must wait [DisplayTimeText(COOLDOWN_TIMELEFT(src, step_cd))] before crossing the Gauntlet again."))
		return
	if(casting)
		to_chat(owner, span_warning("You are already crossing the Gauntlet!"))
		return
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/C = owner
	if(C.stat >= SOFT_CRIT)
		return
	if(C.in_frenzy)
		to_chat(C, span_warning("You cannot focus your spirit while in frenzy!"))
		return
	if(!C.auspice)
		return
	if(C.auspice.gnosis < 1)
		to_chat(C, span_warning("You don't have enough <b>GNOSIS</b> to step sideways!"))
		SEND_SOUND(C, sound('code/modules/wod13/sounds/werewolf_cast_failed.ogg', 0, 0, 75))
		return

	var/turf/here = get_turf(C)
	if(!here)
		return
	var/going_to_penumbra
	if(is_earth_zlevel(here.z))
		going_to_penumbra = TRUE
	else if(is_penumbra_zlevel(here.z))
		going_to_penumbra = FALSE
	else
		to_chat(C, span_warning("The Gauntlet here is too thick to pierce - you cannot Step Sideways from this place."))
		SEND_SOUND(C, sound('code/modules/wod13/sounds/werewolf_cast_failed.ogg', 0, 0, 75))
		return

	adjust_gnosis(-1, C, FALSE)
	COOLDOWN_START(src, step_cd, step_cooldown)

	to_chat(C, span_notice("You feel for the seam of the Gauntlet..."))
	var/successes = secret_vampireroll(C.auspice.start_gnosis, 7, C, FALSE, TRUE, 0)

	if(successes == -1)
		to_chat(C, span_userdanger("Your spirit recoils violently as the Gauntlet rejects you!"))
		C.Stun(3 SECONDS)
		playsound(get_turf(C), 'code/modules/wod13/sounds/werewolf_cast_failed.ogg', 75, FALSE)
		return

	if(successes == 0)
		to_chat(C, span_warning("The Gauntlet refuses to part for you..."))
		playsound(get_turf(C), 'code/modules/wod13/sounds/werewolf_cast_failed.ogg', 75, FALSE)
		return

	var/turf/target = find_step_sideways_target(C, going_to_penumbra)
	if(!target)
		to_chat(C, span_warning("You cannot find a path through the Gauntlet here..."))
		return

	var/cast_time = max(2 SECONDS, (7 - successes) SECONDS)
	casting = TRUE
	to_chat(C, span_notice("You begin to step sideways, the world around you growing thin..."))
	playsound(get_turf(C), 'code/modules/wod13/sounds/portal.ogg', 75, FALSE)
	var/matrix/start_matrix = matrix(C.transform)
	var/matrix/cast_matrix = matrix(C.transform)
	cast_matrix.Scale(0.85, 0.85)
	var/initial_alpha = C.alpha
	animate(C, alpha = 0, transform = cast_matrix, time = cast_time, easing = SINE_EASING)

	if(!do_after(C, cast_time, target = C, timed_action_flags = IGNORE_HELD_ITEM, extra_checks = CALLBACK(src, PROC_REF(check_still_casting), C)))
		casting = FALSE
		animate(C, alpha = initial_alpha, transform = start_matrix, time = 2)
		to_chat(C, span_warning("Your concentration breaks - you are pulled back to the material world!"))
		return

	casting = FALSE
	C.stop_pulling()

	if(going_to_penumbra && C.CheckEyewitness(C, C, 5, FALSE))
		C.adjust_veil(-1, honoradj = -1)

	C.forceMove(target)
	C.alpha = initial_alpha
	C.transform = start_matrix
	playsound(target, 'code/modules/wod13/sounds/portal_enter.ogg', 75, FALSE)
	to_chat(C, span_notice(going_to_penumbra ? "You step into the spirit world." : "You step back into the material world."))

/datum/action/gift/step_sideways/proc/check_still_casting(mob/living/carbon/C)
	if(!C || QDELETED(C))
		return FALSE
	if(C.in_frenzy)
		return FALSE
	return TRUE

/proc/is_step_sideways_safe(turf/T, going_to_penumbra)
	if(!T)
		return FALSE
	if(going_to_penumbra)
		if(!is_penumbra_zlevel(T.z))
			return FALSE
	else
		if(!is_earth_zlevel(T.z))
			return FALSE
	if(istype(T, /turf/open/water))
		return FALSE
	if(istype(T, /turf/open/floor/plating/vampocean))
		return FALSE
	if(istype(T, /turf/open/floor/plating/beach/water))
		return FALSE
	if(T.is_blocked_turf())
		return FALSE
	return TRUE

/proc/find_safe_turf_near(turf/center, going_to_penumbra, search_radius = 4)
	if(!center)
		return null
	if(is_step_sideways_safe(center, going_to_penumbra))
		return center
	var/turf/best = null
	var/best_dist = INFINITY
	for(var/turf/candidate in range(search_radius, center))
		if(!is_step_sideways_safe(candidate, going_to_penumbra))
			continue
		var/d = get_dist(candidate, center)
		if(d < best_dist)
			best_dist = d
			best = candidate
	return best

/proc/find_step_sideways_target(mob/living/source, going_to_penumbra)
	if(!source)
		return null
	var/turf/source_turf = get_turf(source)
	if(!source_turf)
		return null
	var/paired_z = get_paired_zlevel(source_turf.z)
	if(!paired_z)
		return null
	var/turf/direct_target = locate(source_turf.x, source_turf.y, paired_z)
	return find_safe_turf_near(direct_target, going_to_penumbra, 6)

/datum/action/gift/meditate
	name = "Meditate"
	desc = "Sit still and reach for Gnosis."
	button_icon_state = "meditation"
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS
	rage_req = 0
	gnosis_req = 0
	var/meditating = FALSE
	var/meditate_cooldown = 60 SECONDS
	COOLDOWN_DECLARE(meditate_cd)

/datum/action/gift/meditate/Trigger()
	if(!COOLDOWN_FINISHED(src, meditate_cd))
		to_chat(owner, span_warning("You must wait [DisplayTimeText(COOLDOWN_TIMELEFT(src, meditate_cd))] before meditating again."))
		return
	if(meditating)
		to_chat(owner, span_warning("You are already meditating!"))
		return
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/C = owner
	if(C.stat >= SOFT_CRIT)
		return
	if(C.in_frenzy)
		to_chat(C, span_warning("You cannot focus your spirit while in frenzy!"))
		return
	if(!C.auspice)
		return
	if(C.auspice.gnosis >= C.auspice.start_gnosis)
		to_chat(C, span_warning("Your spirit is already full of <b>GNOSIS</b>."))
		return

	var/turf/here = get_turf(C)
	if(!here)
		return

	var/my_tribe = C.auspice.tribe?.name
	var/is_bsd = (my_tribe == "Black Spiral Dancers")

	var/found_friendly_totem = FALSE
	var/found_hostile_totem = FALSE
	for(var/obj/structure/werewolf_totem/W in GLOB.totems)
		if(!W || W.totem_health <= 0)
			continue
		if(get_dist(C, W) > 5)
			continue
		var/totem_is_bsd = (W.tribe == "Black Spiral Dancers")
		if(totem_is_bsd == is_bsd)
			found_friendly_totem = TRUE
			break
		else
			found_hostile_totem = TRUE

	if(!found_friendly_totem && found_hostile_totem)
		to_chat(C, span_warning("A hostile totem nearby refuses to share its strength with you."))
		return

	var/in_umbra = is_umbra_realm_zlevel(here.z)

	var/cast_time
	if(found_friendly_totem)
		cast_time = 15 SECONDS
	else if(in_umbra)
		cast_time = 40 SECONDS
	else
		to_chat(C, span_warning("There is no place of power here to draw upon."))
		SEND_SOUND(C, sound('code/modules/wod13/sounds/werewolf_cast_failed.ogg', 0, 0, 75))
		return

	COOLDOWN_START(src, meditate_cd, meditate_cooldown)
	meditating = TRUE
	var/start_msg
	var/self_msg
	if(is_bsd)
		start_msg = "[C] drops to one knee, breath shuddering as the Wyrm's whispers crawl into [C.p_their()] mind..."
		self_msg = "You kneel and open yourself to the Wyrm's corruption..."
	else if(HAS_TRAIT(C, TRAIT_CORAX) || iscorax(C) || iscorvid(C) || iscoraxcrinos(C))
		start_msg = "[C] tilts [C.p_their()] head and grows still, listening to Helios on the wind..."
		self_msg = "You still yourself and listen to the song of Helios..."
	else
		start_msg = "[C] drops to one knee and closes [C.p_their()] eyes, listening for Gaia's voice..."
		self_msg = "You kneel and open yourself to Gaia's embrace..."

	C.visible_message(span_notice(start_msg), span_notice(self_msg))
	if(is_bsd)
		playsound(get_turf(C), 'sound/ambience/antag/bloodcult.ogg', 35, FALSE)
	else
		playsound(get_turf(C), 'code/modules/wod13/sounds/inspire.ogg', 35, FALSE)

	if(!do_after(C, cast_time, target = C, extra_checks = CALLBACK(src, PROC_REF(check_still_meditating), C)))
		meditating = FALSE
		to_chat(C, span_warning("Your meditation is broken."))
		return

	meditating = FALSE
	adjust_gnosis(1, C, TRUE)
	if(is_bsd)
		to_chat(C, span_notice("The Wyrm's strength flows into you."))
	else
		to_chat(C, span_notice("Gaia's strength flows into you."))

/datum/action/gift/meditate/proc/check_still_meditating(mob/living/carbon/C)
	if(!C || QDELETED(C))
		return FALSE
	if(C.in_frenzy)
		return FALSE
	return TRUE

/mob/camera/penumbra_peek
	name = "Peeking Eye"
	real_name = "Peeking Eye"
	desc = "A glimpse through the Gauntlet."
	icon = 'icons/mob/cameramob.dmi'
	icon_state = "marker"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	move_on_shuttle = FALSE
	invisibility = 0
	see_invisible = SEE_INVISIBLE_LIVING
	layer = MOB_LAYER
	sight = NONE
	movement_type = GROUND|PHASING|FLYING
	initial_language_holder = /datum/language_holder/universal
	alpha = 0
	density = FALSE
	var/mob/living/carbon/holder

/mob/camera/penumbra_peek/Initialize(mapload, mob/living/carbon/owner_body)
	. = ..()
	holder = owner_body
	if(holder)
		RegisterSignal(holder, COMSIG_LIVING_DEATH, PROC_REF(force_return))
		RegisterSignal(holder, COMSIG_PARENT_QDELETING, PROC_REF(force_return))
		addtimer(CALLBACK(src, PROC_REF(periodic_check)), 2 SECONDS, TIMER_LOOP)
	for(var/i in 1 to 4)
		addtimer(CALLBACK(src, PROC_REF(flicker_nearby_lights)), i * 1 SECONDS)

/mob/camera/penumbra_peek/proc/flicker_nearby_lights()
	if(QDELETED(src))
		return
	var/list/found = list()
	for(var/obj/machinery/light/L in view(7, src))
		found += L
	if(!length(found))
		return
	var/picks = min(rand(1, 3), length(found))
	for(var/i in 1 to picks)
		var/obj/machinery/light/L = pick_n_take(found)
		_penumbra_force_flicker(L)

/proc/_penumbra_force_flicker(obj/machinery/light/L)
	set waitfor = FALSE
	if(QDELETED(L) || L.flickering)
		return
	L.flickering = TRUE
	var/saved_on = L.on
	var/saved_range = L.light_range
	var/saved_power = L.light_power
	var/saved_color = L.light_color
	for(var/i in 1 to rand(6, 12))
		if(QDELETED(L))
			break
		L.on = !L.on
		L.update_icon()
		if(L.on)
			L.set_light(L.brightness, L.bulb_power, L.bulb_colour)
		else
			L.set_light(0)
		sleep(rand(5, 15))
	if(!QDELETED(L))
		L.on = saved_on
		L.update_icon()
		L.set_light(saved_range, saved_power, saved_color)
		L.flickering = FALSE

/mob/camera/penumbra_peek/Destroy()
	if(holder)
		UnregisterSignal(holder, list(COMSIG_LIVING_DEATH, COMSIG_PARENT_QDELETING))
		holder = null
	return ..()

/mob/camera/penumbra_peek/Move(NewLoc, Dir = 0)
	return

/mob/camera/penumbra_peek/forceMove(atom/destination)
	loc = destination

/mob/camera/penumbra_peek/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	return

/mob/camera/penumbra_peek/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	. = ..()
	var/atom/movable/to_follow = speaker
	if(radio_freq)
		var/atom/movable/virtualspeaker/V = speaker
		to_follow = V.source
	var/link
	link = FOLLOW_LINK(src, to_follow)
	if(client?.prefs.chat_on_map && (client.prefs.see_chat_non_mob || ismob(speaker)))
		create_chat_message(speaker, message_language, raw_message, spans)
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods)
	to_chat(src, "[link] [message]")

/mob/camera/penumbra_peek/proc/periodic_check()
	if(QDELETED(src) || QDELETED(holder))
		return
	if(holder.stat >= SOFT_CRIT || holder.in_frenzy)
		force_return()

/mob/camera/penumbra_peek/proc/force_return()
	SIGNAL_HANDLER
	if(QDELETED(src))
		return
	if(holder && client)
		var/client/C = client
		SStgui.on_transfer(src, holder)
		holder.key = key
		holder.client = C
		holder.client?.init_verbs()
		to_chat(holder, span_notice("Your sight returns to your body."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), 1)

/datum/action/gift/peek
	name = "Peek Through the Gauntlet"
	desc = "From the spirit world, glimpse the material plane at your current location. Rolls Gnosis at difficulty 7 - more successes shorten the rite. Costs 1 Gnosis."
	button_icon_state = "peek"
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS
	rage_req = 0
	gnosis_req = 0
	var/peek_cooldown = 30 SECONDS
	COOLDOWN_DECLARE(peek_cd)
	var/casting = FALSE

/datum/action/gift/peek/Trigger()
	if(!COOLDOWN_FINISHED(src, peek_cd))
		to_chat(owner, span_warning("You must wait [DisplayTimeText(COOLDOWN_TIMELEFT(src, peek_cd))] before peeking again."))
		return
	if(casting)
		to_chat(owner, span_warning("You are already focusing your sight!"))
		return
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/C = owner
	if(C.stat >= SOFT_CRIT)
		return
	if(C.in_frenzy)
		to_chat(C, span_warning("You cannot focus your spirit while in frenzy!"))
		return
	if(HAS_TRAIT(C, TRAIT_CORAX) || iscorax(C) || iscoraxcrinos(C) || iscorvid(C))
		return
	if(!C.auspice)
		return
	if(C.auspice.gnosis < 1)
		to_chat(C, span_warning("You don't have enough <b>GNOSIS</b> to peek through the Gauntlet!"))
		SEND_SOUND(C, sound('code/modules/wod13/sounds/werewolf_cast_failed.ogg', 0, 0, 75))
		return

	var/turf/here = get_turf(C)
	if(!here)
		return
	if(!is_penumbra_zlevel(here.z))
		to_chat(C, span_warning("You can only peek into the material world while standing within the Penumbra."))
		return

	var/paired_z = get_paired_zlevel(here.z)
	if(!paired_z)
		to_chat(C, span_warning("The Gauntlet here is too thick to see through."))
		return
	var/turf/peek_target = locate(here.x, here.y, paired_z)
	if(!peek_target)
		to_chat(C, span_warning("You cannot find the matching point on the other side."))
		return

	COOLDOWN_START(src, peek_cd, peek_cooldown)

	to_chat(C, span_notice("You reach with your spirit's sight..."))
	var/successes = secret_vampireroll(C.auspice.start_gnosis, 7, C, FALSE, TRUE, 0)

	if(successes == -1)
		adjust_gnosis(-1, C, FALSE)
		to_chat(C, span_userdanger("Your sight tears as the Gauntlet rejects you!"))
		C.Stun(3 SECONDS)
		playsound(get_turf(C), 'code/modules/wod13/sounds/werewolf_cast_failed.ogg', 75, FALSE)
		return

	if(successes == 0)
		adjust_gnosis(-1, C, FALSE)
		to_chat(C, span_warning("Your sight cannot pierce the veil today..."))
		playsound(get_turf(C), 'code/modules/wod13/sounds/werewolf_cast_failed.ogg', 75, FALSE)
		return

	var/cast_time = max(2 SECONDS, (7 - successes) SECONDS)
	casting = TRUE
	C.visible_message(span_notice("[C] kneels and gazes through the Gauntlet..."), span_notice("You begin to focus your sight through the Gauntlet..."))
	playsound(get_turf(C), 'code/modules/wod13/sounds/inspire.ogg', 35, FALSE)

	if(!do_after(C, cast_time, target = C, extra_checks = CALLBACK(src, PROC_REF(check_still_focusing), C)))
		casting = FALSE
		to_chat(C, span_warning("Your focus breaks!"))
		return

	casting = FALSE
	adjust_gnosis(-1, C, FALSE)

	var/mob/camera/penumbra_peek/peek_eye = new(peek_target, C)
	peek_eye.real_name = C.real_name
	peek_eye.name = "[C.real_name]'s Sight"

	if(C.client)
		SStgui.on_transfer(C, peek_eye)
		peek_eye.key = C.key
		peek_eye.client?.init_verbs()

	var/datum/action/penumbra_peek_return/return_action = new()
	return_action.Grant(peek_eye)

	to_chat(peek_eye, span_notice("Your spirit's eye opens upon the material world..."))
	SEND_SOUND(peek_eye, sound('code/modules/wod13/sounds/portal.ogg', 0, 0, 75))

/datum/action/gift/peek/proc/check_still_focusing(mob/living/carbon/C)
	if(!C || QDELETED(C))
		return FALSE
	if(C.in_frenzy)
		return FALSE
	return TRUE

/datum/action/penumbra_peek_return
	name = "Return to your Body"
	desc = "Pull your spirit's sight back to your physical form."
	button_icon_state = "peek"
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	button_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	check_flags = NONE

/datum/action/penumbra_peek_return/Trigger()
	if(!istype(owner, /mob/camera/penumbra_peek))
		return
	var/mob/camera/penumbra_peek/peek_eye = owner
	peek_eye.force_return()

/datum/client_colour/penumbra
	colour = list(
		0.7, 0.15, 0.15, 0,
		0.15, 0.75, 0.15, 0,
		0.25, 0.25, 0.85, 0,
		0, 0, 0, 1,
	)
	priority = 1000
	fade_in = 1 SECONDS
	fade_out = 1 SECONDS

/mob/living
	var/penumbra_atmosphere_active = FALSE

/mob/living/proc/update_penumbra_atmosphere()
	var/in_penumbra = is_penumbra_zlevel(z)
	if(in_penumbra && !penumbra_atmosphere_active)
		add_client_colour(/datum/client_colour/penumbra)
		ADD_TRAIT(src, TRAIT_NIGHT_VISION, "penumbra_atmosphere")
		update_sight()
		penumbra_atmosphere_active = TRUE
	else if(!in_penumbra && penumbra_atmosphere_active)
		remove_client_colour(/datum/client_colour/penumbra)
		REMOVE_TRAIT(src, TRAIT_NIGHT_VISION, "penumbra_atmosphere")
		update_sight()
		penumbra_atmosphere_active = FALSE

/mob/living/onTransitZ(old_z, new_z)
	..()
	update_penumbra_atmosphere()

/mob/living/Login()
	..()
	update_penumbra_atmosphere()

#undef DOGGY_ANIMATION_COOLDOWN
