/////////////////////////////////////
//////////Limb Grower Designs ///////
/////////////////////////////////////

/datum/design/beer
	name = "Beer"
	id = "beer"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 25)
	build_path = /obj/item/reagent_containers/food/drinks/beer/vampire/blue_stripe
	category = list("initial", "King Breweries and Distilleries")

/datum/design/colabottle
	name = "Cola bottle"
	id = "colabottle"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 25)
	build_path = /obj/item/reagent_containers/food/drinks/bottle/vampirecola/blue
	category = list("initial", "King Breweries and Distilleries")

/datum/design/colacan
	name = "Cola can"
	id = "colacan"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 15)
	build_path = /obj/item/reagent_containers/food/drinks/soda_cans/vampirecola/blue
	category = list("initial", "King Breweries and Distilleries")

/datum/design/bluedonut
	name = "Donut"
	id = "bluedonut"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 10)
	build_path = /obj/item/food/donut/jelly/slimejelly
	category = list("initial", "King Breweries and Distilleries")

/datum/design/bluecigs
	name = "Carp Classic cigarettes"
	id = "bluecigs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 10)
	build_path = /obj/item/storage/fancy/cigarettes/cigpack_carp
	category = list("initial", "Circinus Brands")

/datum/design/slimetoy
	name = "Slime toy"
	id = "slimetoy"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 20)
	build_path = /obj/item/toy/plush/slimeplushie
	category = list("initial", "Avalon Incorporated")

/datum/design/carptoy
	name = "Carp toy"
	id = "carptoy"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 20)
	build_path = /obj/item/toy/plush/carpplushie
	category = list("initial", "Avalon Incorporated")

/datum/design/supplements
	name = "Supplements pills"
	id = "supplements"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 50)
	build_path = /obj/item/storage/pill_bottle/probital
	category = list("initial", "Magadon Incorporated")

/datum/design/glock21
	name = "Glock21"
	id = "glock21"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 100)
	build_path = /obj/item/gun/ballistic/automatic/vampire/glock21
	category = list("initial", "Herculean Firearms Incorporated")

/datum/design/glockmagazine
	name = "Glock21 magazine"
	id = "glockmagazine"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 50)
	build_path = /obj/item/ammo_box/magazine/vampire/glock45acp
	category = list("initial", "Herculean Firearms Incorporated")

/datum/design/c45acp
	name = "Glock21 ammo"
	id = "c45acp"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 100)
	build_path = /obj/item/ammo_box/vampire/c45acp
	category = list("initial", "Herculean Firearms Incorporated")

/datum/design/slimemeat
	name = "Meat"
	id = "slimemeat"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 10)
	build_path = /obj/item/food/meat/slab/human/mutant/slime
	category = list("initial", "Young and Smith Incorporated")

/datum/design/slimecake
	name = "Cake"
	id = "slimecake"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 50)
	build_path = /obj/item/food/cake/slimecake
	category = list("initial", "Young and Smith Incorporated")

/datum/design/blumpkin
	name = "Blumpkin"
	id = "blumpkin"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/fuel/oil = 20)
	build_path = /obj/item/food/grown/blumpkin
	category = list("initial", "Young and Smith Incorporated")

/////////////////////////////////////////////////////////////////////////////

/obj/item/disk/design_disk/contract
	name = "Сontract"
	var/contract = list()

/obj/item/disk/design_disk/contract/Initialize(mapload)
	. = ..()
	for(var/design in contract)
		var/datum/design/new_design = design
		blueprints += new new_design

/obj/item/disk/design_disk/contract/breweriescontract
	name = "King Breweries and Distilleries contract"
	contract = list(/datum/design/beer, /datum/design/colabottle, /datum/design/colacan, /datum/design/bluedonut)

/obj/item/disk/design_disk/contract/circinuscontract
	name = "Circinus Brands contract"
	contract = list(/datum/design/bluecigs)

/obj/item/disk/design_disk/contract/avaloncontract
	name = "Avalon Incorporated contract"
	contract = list(/datum/design/carptoy, /datum/design/slimetoy)

/obj/item/disk/design_disk/contract/magadoncontract
	name = "Magadon Incorporated contract"
	contract = list(/datum/design/supplements)

/obj/item/disk/design_disk/contract/herculeancontract
	name = "Herculean Firearms Incorporated contract"
	contract = list(/datum/design/glock21, /datum/design/glockmagazine, /datum/design/c45acp)

/obj/item/disk/design_disk/contract/youngcontract
	name = "Young and Smith Incorporated contract"
	blueprints = list(/datum/design/slimemeat, /datum/design/slimecake, /obj/item/food/grown/blumpkin)


