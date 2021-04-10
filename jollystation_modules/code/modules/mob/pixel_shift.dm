/mob/living
	var/pixel_shifted = FALSE

/mob/living/verb/open_pixel_shift_ui()
	set name = "Pixel Shift"
	set category = "IC"

	if(pixel_shifted)
		return

	if(stat != CONSCIOUS)
		to_chat(src, "<span class='danger'>You need to be conscious to use pixel shifting.</span>")
		return

	if(incapacitated())
		to_chat(src, "<span class='danger'>You aren't able to use pixel shifting right now.</span>")
		return

	if(combat_mode)
		to_chat(src, "<span class='danger'>You can't use pixel shifting while in combat mode.</span>")
		return

	var/datum/pixel_shift_ui/tgui = new(src)
	tgui.ui_interact(src)

/datum/pixel_shift_ui
	var/mob/living/ui_user
	var/x_shift = 0
	var/y_shift = 0

/datum/pixel_shift_ui/New(mob/living/user)
	ui_user = user
	ui_user.pixel_shifted = TRUE
	if(!istype(ui_user))
		CRASH("pixel_shift_ui passed a non-living mob")

	x_shift = user.pixel_x
	y_shift = user.pixel_y
	RegisterSignal(ui_user, COMSIG_MOVABLE_PRE_MOVE, .proc/reset_offsets)

/datum/pixel_shift_ui/ui_close(mob/user)
	UnregisterSignal(ui_user, COMSIG_MOVABLE_PRE_MOVE)
	reset_offsets()
	ui_user.pixel_shifted = FALSE
	qdel(src)

/datum/pixel_shift_ui/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/datum/pixel_shift_ui/ui_data(mob/user)
	var/list/data = list()
	data["x_shift"] = x_shift
	data["y_shift"] = y_shift

	return data

/datum/pixel_shift_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_PixelShift")
		ui.open()

/datum/pixel_shift_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("shift_x")
			x_shift = clamp(params["shift_amount"] + x_shift, -16, 16)
			update_offsets()
		if("shift_y")
			y_shift = clamp(params["shift_amount"] + y_shift, -16, 16)
			update_offsets()
		if("reset_shift")
			reset_offsets()

	return TRUE

/datum/pixel_shift_ui/proc/update_offsets()
	ui_user.pixel_x = x_shift
	ui_user.pixel_y = y_shift

/datum/pixel_shift_ui/proc/reset_offsets()
	x_shift = ui_user.base_pixel_x + ui_user.body_position_pixel_x_offset
	y_shift = ui_user.base_pixel_y + ui_user.body_position_pixel_y_offset
	update_offsets()
