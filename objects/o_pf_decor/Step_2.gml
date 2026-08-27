event_inherited();

// Collision
if (collide_while_plat or collide_ow) and instance_exists(get_leader())
    collide = (get_leader().pf_enabled ? collide_while_plat : collide_ow);

// Y
if instance_exists(wall_parent) and instance_exists(o_dev_pf_controller) {
	var abc_a = wall_parent.y - (wall_parent.floor_backlength_in_tiles * wall_parent.tilesize * (1-((1-max(wall_parent.perspectiveangle, 0.02))*global.platforming_perspective)))
	var abc_s = wall_parent.__y_while_not_pf - (wall_parent.floor_backlength_in_tiles * wall_parent.tilesize)
	var def = (ystart - abc_s) / (wall_parent.__y_while_not_pf - abc_s)
	y = lerp(abc_a, wall_parent.y, def)
	y = lerp(y, y + o_dev_pf_controller.default_platformsdrawyoffset, global.platforming_perspective)
}
