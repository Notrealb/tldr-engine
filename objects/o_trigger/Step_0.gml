if span_vertical {
	y = -1000;
	image_yscale = 3000;
}
if span_horizontal {
	x = -1000;
	image_xscale = 3000;
}
if place_meeting(x, y, get_leader()) {
	var check_can = can_trigger && ((can_while_platforming and global.platforming_perspective) or (can_while_not_platforming and global.platforming_perspective == 0))
	if !triggered && !controlled_activation && check_can
		event_user(0)
    else if !triggered && controlled_activation && instance_exists(get_leader()) && get_leader()._checkmove() && check_can
        event_user(0)
    
    if triggered
        trigger_step_code()
}
else if trigger_exit {
	event_user(1)
}