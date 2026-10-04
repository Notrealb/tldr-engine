event_inherited();

if hitstop > 0
	hitstop = max(0, hitstop-1);

// Y and Darken
if instance_exists(wall_parent) and instance_exists(o_dev_plat_controller) {
	var abc_a = wall_parent.y - (wall_parent.floor_backlength_in_tiles * wall_parent.tilesize * (1-((1-max(wall_parent.perspectiveangle, 0.02))*global.platforming_perspective)));
	var abc_s = wall_parent.__y_while_not_pf - (wall_parent.floor_backlength_in_tiles * wall_parent.tilesize);
	var def = (ystart - abc_s) / (wall_parent.__y_while_not_pf - abc_s);
	y = lerp(abc_a, wall_parent.y, def);
	y = lerp(y, y + o_dev_plat_controller.default_platformsdrawyoffset, global.platforming_perspective);
	
	if darken > 0
		image_blend = merge_color(image_blend_start, darken_color, (1-def) * global.platforming_perspective * clamp(darken, 0, 1));
}
