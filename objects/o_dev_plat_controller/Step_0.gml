//if keyboard_check(vk_comma) default_perspectiveangle-=0.1
//if keyboard_check(vk_period) default_perspectiveangle+=0.1
//if keyboard_check(vk_fslash) default_perspectiveangle=0.1
//o_plat_wall.perspectiveangle = default_perspectiveangle


if keyboard_check_pressed(vk_comma) player_floor_centering-=0.1
if keyboard_check_pressed(vk_period) player_floor_centering+=0.1
if keyboard_check_pressed(vk_fslash) player_floor_centering=0.5