// Important Contacts

GLOBAL_LIST_INIT(important_contacts, alist())

// Contact Networks

GLOBAL_LIST_INIT(millenium_tower_network, list())
GLOBAL_LIST_INIT(lasombra_network, list())
GLOBAL_LIST_INIT(tremere_network, list())
GLOBAL_LIST_INIT(giovanni_network, list())
GLOBAL_LIST_INIT(tzmisce_network, list())
GLOBAL_LIST_INIT(anarch_network, list())
GLOBAL_LIST_INIT(warehouse_network, list())
GLOBAL_LIST_INIT(triads_network, list())
GLOBAL_LIST_INIT(vampire_leader_network, list())

GLOBAL_LIST_INIT(weaver_network, list())
GLOBAL_LIST_INIT(wyrm_network, list())
GLOBAL_LIST_INIT(gaia_network, list())

/proc/contact_network_from_define(network_id)
	switch(network_id)
		if(MILLENIUM_TOWER_NETWORK)
			return GLOB.millenium_tower_network
		if(LASOMBRA_NETWORK)
			return GLOB.lasombra_network
		if(TREMERE_NETWORK)
			return GLOB.tremere_network
		if(GIOVANNI_NETWORK)
			return GLOB.giovanni_network
		if(TZMISCE_NETWORK)
			return GLOB.tzmisce_network
		if(ANARCH_NETWORK)
			return GLOB.anarch_network
		if(WAREHOUSE_NETWORK)
			return GLOB.warehouse_network
		if(TRIADS_NETWORK)
			return GLOB.triads_network
		if(VAMPIRE_LEADER_NETWORK)
			return GLOB.vampire_leader_network

		if(WEAVER_NETWORK)
			return GLOB.weaver_network
		if(WYRM_NETWORK)
			return GLOB.wyrm_network
		if(GAIA_NETWORK)
			return GLOB.gaia_network
	CRASH("contact_network_from_define() called with invalid network_id: [isnull(network_id) ? "(null)" : network_id]")
