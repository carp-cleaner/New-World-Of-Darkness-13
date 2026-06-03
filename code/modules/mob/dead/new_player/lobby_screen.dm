GLOBAL_DATUM_INIT(lobby_screen, /datum/lobby_screen, new)

/datum/lobby_screen
	var/lobby_html

/datum/lobby_screen/New()
	. = ..()
	lobby_html = file2text('html/lobby/index.html')

/datum/lobby_screen/proc/show(client/user)
	if (user?.interviewee)
		return
	var/datum/asset/asset_datum = get_asset_datum(/datum/asset/simple/lobby)
	asset_datum.send(user)

	var/output = replacetext_char(lobby_html, "\[player-ref]", "[REF(user.mob)]")
	winset(user, "lobbybrowser", "is-disabled=false;is-visible=true")
	user.mob << browse(output,"window=lobbybrowser")

/datum/lobby_screen/proc/hide(client/user)
	if(user.mob)
		user.mob << browse(null, "window=lobbybrowser")
		winset(user, "lobbybrowser", "is-disabled=true;is-visible=false")

/datum/lobby_screen/proc/update_to_all()
	for(var/mob/dead/new_player/player in GLOB.player_list)
		update(player.client)

/datum/lobby_screen/proc/update(client/user)
	var/state = SSticker.current_state
	var/mob/dead/new_player/player = user.mob
	user << output("[state]-[player.ready]-[player.late_ready]", "lobbybrowser:setStatus")
