
/obj/structure/vampdoor/old
	icon_state = "old-1"
	baseicon = "old"

/obj/structure/vampdoor/simple
	icon_state = "cam-1"
	baseicon = "cam"

/obj/structure/vampdoor/reinf
	icon_state = "reinf-1"
	baseicon = "reinf"

/obj/structure/vampdoor/reinf/ship
	icon_state = "gateway-1"
	baseicon = "gateway"

/obj/structure/vampdoor/prison
	icon_state = "prison-1"
	opacity = FALSE
	baseicon = "prison"
	glass = TRUE
	lockpick_difficulty = 8

/obj/structure/vampdoor/wood
	icon_state = "wood-1"
	baseicon = "wood"
	burnable = TRUE

/obj/structure/vampdoor/wood/old
	icon_state = "oldwood-1"
	baseicon = "oldwood"

/obj/structure/vampdoor/glass
	icon_state = "glass-1"
	opacity = FALSE
	baseicon = "glass"
	glass = TRUE
	burnable = TRUE

/obj/structure/vampdoor/shop
	icon_state = "shop-1"
	opacity = FALSE
	baseicon = "shop"
	glass = TRUE
	lockpick_difficulty = 7

/obj/structure/vampdoor/camarilla
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "camarilla"
	lockpick_difficulty = 6

/obj/structure/vampdoor/clerk
	icon_state = "shop-1"
	opacity = FALSE
	baseicon = "shop"
	glass = TRUE
	locked = TRUE
	lock_id = "clerk"
	lockpick_difficulty = 7

/obj/structure/vampdoor/pentex
	icon_state = "shop-1"
	opacity = FALSE
	baseicon = "shop"
	glass = TRUE
	locked = TRUE
	lock_id = "pentex"
	lockpick_difficulty = 8

/obj/structure/vampdoor/prince
	icon_state = "glass-1"
	opacity = FALSE
	baseicon = "glass"
	glass = TRUE
	locked = TRUE
	lock_id = "prince"
	burnable = TRUE
	lockpick_difficulty = 7
	magic_lock = TRUE

/obj/structure/vampdoor/daughters
	icon_state = "wood-1"
	baseicon = "wood"
	locked = TRUE
	lock_id = "daughters"
	burnable = TRUE
	lockpick_difficulty = 7

/obj/structure/vampdoor/graveyard
	icon_state = "oldwood-1"
	baseicon = "oldwood"
	locked = TRUE
	lock_id = "graveyard"
	burnable = TRUE
	lockpick_difficulty = 2

/obj/structure/vampdoor/church
	icon_state = "oldwood-1"
	baseicon = "oldwood"
	locked = TRUE
	lock_id = "church"
	burnable = TRUE
	lockpick_difficulty = 7

/obj/structure/vampdoor/clinic
	icon_state = "shop-1"
	opacity = FALSE
	baseicon = "shop"
	glass = TRUE
	locked = TRUE
	lock_id = "clinic"
	lockpick_difficulty = 4

/obj/structure/vampdoor/cleaning
	icon_state = "reinf-1"
	baseicon = "reinf"
	locked = TRUE
	lock_id = "cleaning"
	lockpick_difficulty = 4

/obj/structure/vampdoor/archive
	icon_state = "old-1"
	baseicon = "old"
	locked = TRUE
	lock_id = "archive"
	lockpick_difficulty = 7
	magic_lock = TRUE

/obj/structure/vampdoor/anarch
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "anarch"
	lockpick_difficulty = 7

/obj/structure/vampdoor/bar
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "bar"
	lockpick_difficulty = 7

/obj/structure/vampdoor/supply
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "supply"
	lockpick_difficulty = 6

/obj/structure/vampdoor/npc
	icon_state = "wood-1"
	baseicon = "wood"
	locked = TRUE
	lock_id = "npc"
	burnable = TRUE
	lockpick_difficulty = 4

/obj/structure/vampdoor/police
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "police"
	lockpick_difficulty = 6

/obj/structure/vampdoor/police/secure
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "police_secure"
	lockpick_difficulty = 10

/obj/structure/vampdoor/police/chief
	icon_state = "shop-1"
	opacity = FALSE
	locked = TRUE
	baseicon = "shop"
	glass = TRUE
	lock_id = "police_chief"
	lockpick_difficulty = 10

/obj/structure/vampdoor/prison
	icon_state = "prison-1"
	baseicon = "prison"
	locked = TRUE
	glass = TRUE
	lock_id = "police"
	lockpick_difficulty = 6

/obj/structure/vampdoor/strip
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "strip"
	lockpick_difficulty = 4

/obj/structure/vampdoor/giovanni
	icon_state = "wood-1"
	baseicon = "wood"
	locked = TRUE
	lock_id = "giovanni"
	burnable = TRUE
	lockpick_difficulty = 6

/obj/structure/vampdoor/baali
	icon_state = "oldwood-1"
	baseicon = "oldwood"
	locked = TRUE
	lock_id = "baali"
	burnable = FALSE
	lockpick_difficulty = 6
	magic_lock = TRUE

/obj/structure/vampdoor/salubri
	icon_state = "oldwood-1"
	baseicon = "oldwood"
	locked = TRUE
	lock_id = "salubri"
	burnable = FALSE
	lockpick_difficulty = 6

/obj/structure/vampdoor/old_clan_tzimisce
	icon_state = "oldwood-1"
	baseicon = "oldwood"
	locked = TRUE
	lock_id = "old_clan_tzimisce"
	burnable = FALSE
	lockpick_difficulty = 6
	magic_lock = TRUE

/obj/structure/vampdoor/npc/Initialize(mapload)
	. = ..()
	lock_id = "npc[rand(1, 20)]"

