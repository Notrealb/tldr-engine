if !instance_exists(o_dodge_controller)
    exit

image_alpha = o_dodge_controller.dodge_alpha
if image_alpha == 0 
	instance_destroy()

var bulletcheck = instance_place(x, y, o_dodge_bullet)
if bulletcheck && i_frames == 0 && (get_leader()._checkmove() || climb_check()) {
	with bulletcheck
		event_user(1)
}
if global.platforming_perspective == 1 {
	bulletcheck = instance_place(x, y, o_plat_bullet)
	if bulletcheck && i_frames == 0 && (get_leader()._checkmove() || climb_check()) {
		with bulletcheck
			event_user(2)
	}
}
if i_frames > 0 {
	i_frames --;
	image_speed = .25;
} 
else {
	image_speed = 0;
	image_index = 0;
	i_frames = 0;
}
if global.platforming_perspective == 1 {
	image_index = i_frames;
}