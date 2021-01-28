/datum/controller/subsystem/processing/quirks
	// Add in quirk blackists here. Format is a list of a list of quirks that are incompatible.
	var/list/module_blacklist = list(list("Size - Extremely Large", "Size - Very Large", "Size - Large", "Size - Average Height", "Size - Small", "Size - Very Small", "Size - Extremely Small"))

/datum/controller/subsystem/processing/quirks/Initialize()
	. = ..()
	quirk_blacklist.Add(module_blacklist)
