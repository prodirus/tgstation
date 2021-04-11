#define COMSIG_PIXELSHIFT_POSY "pixelshift_posy"
#define COMSIG_PIXELSHIFT_POSX "pixelshift_posx"
#define COMSIG_PIXELSHIFT_NEGY "pixelshift_negy"
#define COMSIG_PIXELSHIFT_NEGX "pixelshift_negx"

#define COMSIG_PIXELSHIFT_RESET "pixelshift_reset"
#define COMSIG_PIXELSHIFT_STOP "pixelshift_stop"

/datum/keybinding/mob/prevent_movement/can_use(client/user)
	var/mob/living/our_mob = user.mob
	if(istype(our_mob))
		if(our_mob.pixel_shifted)
			return FALSE
	return ..()

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

	var/datum/pixel_shift_ui/tgui = new(src)
	tgui.ui_interact(src)

/datum/pixel_shift_ui
	var/mob/living/ui_user

/datum/pixel_shift_ui/New(mob/living/user)
	ui_user = user
	ui_user.AddComponent(/datum/component/pixel_shift)

/datum/pixel_shift_ui/ui_close(mob/user)
	SEND_SIGNAL(ui_user, COMSIG_PIXELSHIFT_STOP)
	qdel(src)

/datum/pixel_shift_ui/ui_status(mob/user, datum/ui_state/state)
	if(!ui_user.pixel_shifted)
		return UI_CLOSE
	if(ui_user.stat != CONSCIOUS)
		return UI_CLOSE
	if(ui_user.incapacitated())
		return UI_DISABLED
	return UI_INTERACTIVE

/datum/pixel_shift_ui/ui_data(mob/user)
	var/list/data = list()
	data["x_shift"] = ui_user.pixel_x
	data["y_shift"] = ui_user.pixel_y

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
		if("shift_posx")
			SEND_SIGNAL(ui_user, COMSIG_PIXELSHIFT_POSX)
		if("shift_negx")
			SEND_SIGNAL(ui_user, COMSIG_PIXELSHIFT_NEGX)
		if("shift_posy")
			SEND_SIGNAL(ui_user, COMSIG_PIXELSHIFT_POSY)
		if("shift_negy")
			SEND_SIGNAL(ui_user, COMSIG_PIXELSHIFT_NEGY)
		if("reset_shift")
			SEND_SIGNAL(ui_user, COMSIG_PIXELSHIFT_RESET)

	return TRUE

/datum/component/pixel_shift
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/living_parent
	var/x_shift = 0
	var/y_shift = 0

/datum/component/pixel_shift/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	living_parent = parent
	living_parent.client.movement_locked = TRUE
	living_parent.pixel_shifted = TRUE
	x_shift = living_parent.pixel_x
	y_shift = living_parent.pixel_y

	RegisterSignal(parent, list(COMSIG_MOVABLE_PRE_MOVE, COMSIG_PIXELSHIFT_RESET), .proc/reset_offsets)
	RegisterSignal(parent, list(COMSIG_KB_MOVEMENT_NORTH_DOWN, COMSIG_PIXELSHIFT_POSY), .proc/shift_pos_y)
	RegisterSignal(parent, list(COMSIG_KB_MOVEMENT_EAST_DOWN, COMSIG_PIXELSHIFT_POSX), .proc/shift_pos_x)
	RegisterSignal(parent, list(COMSIG_KB_MOVEMENT_SOUTH_DOWN, COMSIG_PIXELSHIFT_NEGY), .proc/shift_neg_y)
	RegisterSignal(parent, list(COMSIG_KB_MOVEMENT_WEST_DOWN, COMSIG_PIXELSHIFT_NEGX), .proc/shift_neg_x)
	RegisterSignal(parent, list(COMSIG_LIVING_RESIST, COMSIG_LIVING_GET_PULLED, COMSIG_PIXELSHIFT_STOP), .proc/stop_pixel_shift)

	to_chat(parent, "<span class='notice'>You are now pixel shifting. Movement has been locked. <b>Resist</b> or close the UI to stop pixel shifting.</span>")

/datum/component/pixel_shift/Destroy()
	reset_offsets()
	living_parent.client.movement_locked = FALSE
	living_parent.pixel_shifted = FALSE
	living_parent = null
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_PRE_MOVE,
		COMSIG_PIXELSHIFT_RESET,
		COMSIG_LIVING_RESIST,
		COMSIG_LIVING_GET_PULLED,
		COMSIG_PIXELSHIFT_STOP,
		COMSIG_KB_MOVEMENT_NORTH_DOWN,
		COMSIG_PIXELSHIFT_POSY,
		COMSIG_KB_MOVEMENT_EAST_DOWN,
		COMSIG_PIXELSHIFT_POSX,
		COMSIG_KB_MOVEMENT_SOUTH_DOWN,
		COMSIG_PIXELSHIFT_NEGY,
		COMSIG_KB_MOVEMENT_WEST_DOWN,
		COMSIG_PIXELSHIFT_NEGX,
	))

	to_chat(parent, "<span class='notice'>You are no longer pixel shifting. Movement has been unlocked.</span>")
	return ..()

/datum/component/pixel_shift/proc/shift_pos_y(datum/source)
	SIGNAL_HANDLER

	y_shift = clamp(y_shift + 1, -16, 16)
	update_offsets()

/datum/component/pixel_shift/proc/shift_pos_x(datum/source)
	SIGNAL_HANDLER

	x_shift = clamp(x_shift + 1, -16, 16)
	update_offsets()

/datum/component/pixel_shift/proc/shift_neg_y(datum/source)
	SIGNAL_HANDLER

	y_shift = clamp(y_shift - 1, -16, 16)
	update_offsets()

/datum/component/pixel_shift/proc/shift_neg_x(datum/source)
	SIGNAL_HANDLER

	x_shift = clamp(x_shift - 1, -16, 16)
	update_offsets()

/datum/component/pixel_shift/proc/reset_offsets()
	SIGNAL_HANDLER

	x_shift = living_parent.base_pixel_x + living_parent.body_position_pixel_x_offset
	y_shift = living_parent.base_pixel_y + living_parent.body_position_pixel_y_offset
	update_offsets()

/datum/component/pixel_shift/proc/stop_pixel_shift()
	SIGNAL_HANDLER

	reset_offsets()
	qdel(src)

/datum/component/pixel_shift/proc/update_offsets()
	living_parent.pixel_x = x_shift
	living_parent.pixel_y = y_shift
