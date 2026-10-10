event_inherited();
call_later(1, time_source_units_frames, function(){
	if hide_while_not_platforming and global.platforming_perspective < 1
		image_alpha = 0;
})

dodgeaura_radius = 0
dodgeaura_inst = noone
dodgeaura_use_while_platforming = true
dodgeaura_use_while_not_platforming = false
hide_while_not_platforming = true
dmg = 1

fling_y = -6
fling_x_abs = 0 // 8 is a good value
fling_dir = 0 // -1 is left, 0 is automatic, 1 is right.

hitstop = 0