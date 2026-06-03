#define ACTION_HEADSHOT_LINK_NOOP 0
#define ACTION_HEADSHOT_LINK_REMOVE -1

#define HEADSHOT_LINK_MAX_LENGTH 220


/datum/preferences/process_link(mob/user, list/href_list)
	switch(href_list["preference"])
		if ("headshot")
			set_headshot_link(user, "headshot_link")
	return ..()


/datum/preferences/proc/set_headshot_link(mob/user, link_id)
	var/headshot_link = get_headshot_link(user, features[link_id])
	switch(headshot_link)
		if (ACTION_HEADSHOT_LINK_REMOVE)
			features[link_id] = null
			return
		if (ACTION_HEADSHOT_LINK_NOOP)
			return
		else
			if(features[link_id] == headshot_link)
				return

			to_chat(user, "Если картинка не отображается в игре должным образом, убедитесь, что это прямая ссылка на изображение, которая правильно открывается в обычном браузере.")
			to_chat(user, "Имейте в виду, что размер фотографии будет уменьшен до 256x256 пикселей, поэтому чем квадратнее фотография, тем лучше она будет выглядеть.")

			features[link_id] = headshot_link


/datum/preferences/proc/get_headshot_link(mob/user, old_link)
	var/usr_input = input(user, "Вставьте ссылку на изображение: (Для дискорд ссылок попытайтесь в конце, после \"&\"вставить тип файла. Для примера '&.jpg/.png/.jpeg')", "Headshot Image", old_link) as text|null
	if(isnull(usr_input))
		return ACTION_HEADSHOT_LINK_NOOP

	if(!usr_input)
		return ACTION_HEADSHOT_LINK_REMOVE
	var/nigga = "]"

	var/static/link_regex = regex("^(https://i\\.gyazo\\.com|https://static1\\.e621\\.net|https://i\\.ibb\\.co/||https://cdn\\.discordapp\\.com)")
	var/static/end_regex = regex("(\\.jpg|\\.png|\\.jpeg)$")

	if (length(usr_input) > HEADSHOT_LINK_MAX_LENGTH)
		to_chat(user, "<span class='warning'>Ссылка слишком большая! Максимальная длина: [HEADSHOT_LINK_MAX_LENGTH] символов!</span>")
		return ACTION_HEADSHOT_LINK_NOOP

	if(!findtext(usr_input, link_regex))
		to_chat(user, "<span class='warning'>Ссылка должна быть не укороченной Gyazo, iBB, E621, Discord ссылкой!</span>")
		return ACTION_HEADSHOT_LINK_NOOP

	if(!findtext(usr_input, end_regex))
		to_chat(user, "<span class='warning'>Тебе нужно вставить \".png\", \".jpg\", or \".jpeg\" в конце ссылки!</span>")
		return ACTION_HEADSHOT_LINK_NOOP

	if(findtext(usr_input, nigga))
		to_chat(usr, "<span class='reallybig'> Ниггер хакерский. Не используй квадратные скобочки. </span>")
		message_admins("[ADMIN_LOOKUPFLW(usr)] пытался вставить в ХЭДШОТ хуйню с квадратными скобочками")
		return ACTION_HEADSHOT_LINK_NOOP
	var/static/list/repl_chars = list("\n"="#","\t"="#","'"="","\""=""," "="")
	return trim(usr_input, repl_chars)

#undef HEADSHOT_LINK_MAX_LENGTH

#undef ACTION_HEADSHOT_LINK_NOOP
#undef ACTION_HEADSHOT_LINK_REMOVE
