///Spawns a cargo pod containing a random cargo supply pack on a random area of the station
/datum/round_event_control/resource_pods
	name = "Resource Pods"
	typepath = /datum/round_event/resource_pods
	weight = 25
	earliest_start = 5 MINUTES

/datum/round_event/resource_pods
	var/num_pods = 1
	var/pod_style = STYLE_STANDARD
	var/area/impact_area
	var/static/list/possible_crates = list()
	var/list/obj/structure/closet/crate/picked_crates = list()

/datum/round_event/resource_pods/announce(fake)
	switch(pod_style)
		if(STYLE_SYNDICATE)
			priority_announce("A recent raid on a [get_syndicate_sources()] in your sector resulted in a [get_num_pod_identifier()] of resources confiscated by Nanotrasen strike team personnel. \
							Given the occurance of the raid in your sector, we're sharing [num_pods] of the resource caches. They'll arrive shortly in: [impact_area.name].")
		if(STYLE_CENTCOM)
			priority_announce("Recent company activity [get_nanotrasen_sources()] in your sector resulted in a [get_num_pod_identifier()] of resources obtained by Nanotrasen shareholders. \
							[num_pods] of the resource caches are being shared with your station as an investment. They'll arrive shortly in: [impact_area.name].")
		else
			priority_announce("A [get_company_sources()] has passed through your sector, dropping off a [get_num_pod_identifier()] of resources at central command. \
							[num_pods] of the resource caches are being shared with your station. They'll arrive shortly in: [impact_area.name].")

/**
* Tries to find a valid area, throws an error if none are found
* Also randomizes the start timer
*/
/datum/round_event/resource_pods/setup()
	startWhen = rand(10, 15)
	impact_area = find_event_area()
	if(!impact_area)
		CRASH("No valid areas for cargo pod found.")
	var/list/turf_test = get_area_turfs(impact_area)
	if(!turf_test.len)
		CRASH("Stray Cargo Pod : No valid turfs found for [impact_area] - [impact_area.type]")

	// Get a random style of the pod. Different styles have different potential crates and reports.
	switch(rand(1, 100))
		if(1 to 24)
			pod_style = STYLE_SYNDICATE
		if(25 to 69)
			pod_style = STYLE_CENTCOM
		if(70 to 100)
			pod_style = STYLE_STANDARD

	//Clear and reset the list.
	possible_crates.Cut()

	// Crates we don't want to send.
	var/list/blacklisted_crates = list(/obj/structure/closet/crate/resource_cache/special, \
								/obj/structure/closet/crate/resource_cache/syndicate, \
								/obj/structure/closet/crate/resource_cache/centcom, \
								/obj/structure/closet/crate/resource_cache/special/random_materials)

	// All subtypes of resource_caches, minus the blacklisted crates.
	possible_crates = subtypesof(/obj/structure/closet/crate/resource_cache) - blacklisted_crates
	// Remove subtypes of special crates that don't match our style.
	if(pod_style != STYLE_SYNDICATE)
		possible_crates -= subtypesof(/obj/structure/closet/crate/resource_cache/syndicate)
	if(pod_style != STYLE_CENTCOM)
		possible_crates -= subtypesof(/obj/structure/closet/crate/resource_cache/centcom)
	if(pod_style != STYLE_STANDARD)
		possible_crates -= subtypesof(/obj/structure/closet/crate/resource_cache/special)

	num_pods = rand(2, 5)
	for(var/i in 1 to num_pods)
		picked_crates.Add(pick(possible_crates))


/datum/round_event/resource_pods/start()
	var/list/turf/valid_turfs = get_area_turfs(impact_area)
	for(var/i in valid_turfs)
		var/turf/T = i
		if(T.density)
			valid_turfs -= T
		for(var/obj/stuff in T)
			if(stuff.density)
				valid_turfs -= T

	for(var/crate in picked_crates)
		var/turf/LZ
		if(valid_turfs.len >= picked_crates.len)
			LZ = pick_n_take(valid_turfs)
		else
			LZ = pick(valid_turfs)

		addtimer(CALLBACK(src, .proc/launch_pod, LZ, crate), (2 SECONDS * num_pods--))

/datum/round_event/resource_pods/proc/launch_pod(turf/LZ, obj/structure/closet/crate/crate)
	var/spawned_crate = new crate()
	var/obj/structure/closet/supplypod/pod = new
	pod.setStyle(pod_style)
	pod.explosionSize = list(0,0,1,2)
	var/new_desc = "A standard-style drop pod dropped by the company directly to your station."
	switch(pod_style)
		if(STYLE_SYNDICATE)
			new_desc = "A syndicate-style drop pod reposessed by a Nanotrasen strike force and redirected directly to your station."
		if(STYLE_CENTCOM)
			new_desc = "A nanotrasen-style drop pod dropped by the company directly to your station."

	pod.desc = new_desc
	message_admins("A pod containing a [spawned_crate.type] was launched at [ADMIN_VERBOSEJMP(LZ)] by [src].")
	log_game("A pod containing a [spawned_crate.type] was launched at [loc_name(LZ)] by [src].")

	new /obj/effect/pod_landingzone(LZ, pod, spawned_crate)

///Picks an area that wouldn't risk critical damage if hit by a pod explosion
/datum/round_event/resource_pods/proc/find_event_area()
	var/static/list/allowed_areas
	if(!allowed_areas)
		///Places too sprawling or vague to send stuff
		var/list/bad_area_types = typecacheof(list(
		/area/maintenance)
		)

		///Places that we shouldn't send crates.
		var/list/safe_area_types = typecacheof(list(
		/area/ai_monitored/,
		/area/engine,
		/area/shuttle)
		)

		///Subtypes of places above that are fine to send crates to.
		var/list/unsafe_area_subtypes = typecacheof(list(/area/engine/break_room))

		allowed_areas = make_associative(GLOB.the_station_areas) - safe_area_types + unsafe_area_subtypes - bad_area_types

	var/list/possible_areas = typecache_filter_list(GLOB.sortedAreas,allowed_areas)
	if (length(possible_areas))
		return pick(possible_areas)

/// If the pods are syndicate base, picks a source location based on the number of pods that are sent.
/datum/round_event/resource_pods/proc/get_syndicate_sources()
	if(num_pods >= 4)
		return pick(list("Syndicate base", "Syndicate trade route", "Cybersun industries research facility", "Gorlex fortification", "Donk Co. Factory", "Waffle Co. Factory"))
	else
		return pick(list("Syndicate outpost", "Syndicate trade route", "Gorlex staging post", "Cybersun research expedition", "Syndicate distribution post"))

/// If the pods are NT, picks a source location based on the number of pods that are sent.
/datum/round_event/resource_pods/proc/get_nanotrasen_sources()
	if(num_pods >= 4)
		return pick(list("establishing trade routes", "crypto-currency mining", "conducting plasma research", "gas-giant siphoning", "solar-energy farming", "pulsar ray gathering"))
	else
		return pick(list("asteroid mining", "moon drilling", "crypto-currency mining", "rare-mineral smelting", "solar-energy farming"))

/// If the pods are neither syndie or NT, picks a source location based on the number of pods that are sent.
/datum/round_event/resource_pods/proc/get_company_sources()
	return pick(list("TerraGov trade route", "Space Station [rand(1, 12)] supply shuttle", "Space Station [rand(14, 99)] supply shuttle", "Waffle Co. goods shuttle", "Donk Co. goods shuttle", "Spinward Stellar Coalition relief ship", "Lizard Empire trade route", "Ethereal trade caravan", "Mothperson trade caravan", "Civilian trade caravan"))

/// An adjective describing how many pods are being sent.
/datum/round_event/resource_pods/proc/get_num_pod_identifier()
	switch(num_pods)
		if(1)
			return "small amount"
		if(2)
			return "middling amount"
		if(3)
			return "moderate amount"
		if(4)
			return "large amount"
		if(5)
			return "wealthy amount"
		else
			return "number"
