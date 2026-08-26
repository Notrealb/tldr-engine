// Depth sort
depth = 0
if depth_override
	depth = depth_override;
else if depth_use_wall_depth
	depth = wall_parent.depth - 1;
else if global.platforming_perspective and !depth_override and instance_exists(o_dev_pf_controller) {
	var wt = wall_parent ? wall_parent : instance_place(x, y+2, get_leader().pf_collide);
	if wt {
		var bltts = (wt.floor_backlength_in_tiles * wt.tilesize);
		var d_b = wt.depth;
		var d_f = wt.depth - (bltts * 2);
		depth = lerp(d_f, d_b, abs(ystart - wt.ystart)/bltts)
	}
}
depth += depth_offset
