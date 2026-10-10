event_inherited()
call_later(1, time_source_units_frames, function(){
	if hide_while_platforming and global.platforming_perspective > 0
		image_alpha = 0;
})

dodgeaura_radius = -1
dodgeaura_inst = noone
dodgeaura_use_while_platforming = false
dodgeaura_use_while_not_platforming = true
collide = false
hide_while_platforming = false
dmg = 60