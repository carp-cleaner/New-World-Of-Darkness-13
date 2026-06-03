//TODO
// Admin button to override with your own
// Sabotage objective for tators
// Multiple goals with less impact but more department focused

/datum/vampire_goal
	var/name = "Generic Goal"
	var/weight = 1 //In case of multiple goals later.
	var/required_crew = 10
	var/list/gamemode_blacklist = list()
	var/completed = FALSE
	var/report_message = "Complete this goal."

/datum/vampire_goal/proc/on_report()
	//Additional unlocks/changes go here
	return

/datum/vampire_goal/proc/get_report()
	return report_message

/datum/vampire_goal/proc/check_completion()
	return completed

/datum/vampire_goal/proc/get_result()
	if(check_completion())
		return "<li>[name] :  <span class='greentext'>ВЫПОЛНЕНО!</span></li>"
	else
		return "<li>[name] : <span class='redtext'>ПРОВАЛ!</span></li>"

/datum/vampire_goal/Destroy()
	SSticker.mode.vampire_goals -= src
	. = ..()

/datum/vampire_goal/Topic(href, href_list)
	..()

	if(!check_rights(R_ADMIN) || !usr.client.holder.CheckAdminHref(href, href_list))
		return

	if(href_list["announce"])
		on_report()
	else if(href_list["remove"])
		qdel(src)
