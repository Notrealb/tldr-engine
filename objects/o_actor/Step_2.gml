if is_in_battle and instance_exists(o_enc_bg) and o_enc_bg.alphain == true
    depth = DEPTH_ENCOUNTER.ACTORS - (y - guipos_y());
else if global.platforming_perspective and instance_exists(o_dev_pf_controller) {
	if o_dev_pf_controller.actors_depth_override
		depth = actors_depth_override
	else if o_dev_pf_controller.do_autodepthsort_actors {
		for (var i = 0; i < party_length(true); i ++) {
			if id == party_get_inst(global.party_names[i]) {
				var _c = get_leader().pf_collide
				//if !(place_meeting(x, y, o_pf_wall) and !place_meeting(x, y, _c))
					depth = -party_length(true) + i;
				var wt = instance_place(x, y+2, _c);
				if wt {
					var bltts = (wt.floor_backlength_in_tiles * wt.tilesize);
					var d_b = wt.depth;
					var d_f = wt.depth - (bltts * 2);
					depth = lerp(d_f, d_b, 0.3)
					depth -= party_length(true)
				}
				if i != 0 and depth <= get_leader().depth
					depth = get_leader().depth + i;
			}
		}
	}
}
else
	depth = -2000 - y;
if is_real(depth_override) 
    depth = depth_override;

// record the sliding states
prevsliding = sliding;
s_previous_animation = s_current_animation;

// get the last dirs up/down and left/right
var dirM = cap_wraparound(360 - point_direction(xprevious, yprevious, x, y) + 90, 360);
if y != yprevious {
	if dirM < 85 or dirM > 275 
        last_dir_up_down = DIR.UP;
	if dirM > 95 and dirM < 265 
        last_dir_up_down = DIR.DOWN;
}
if x != xprevious {
	if dirM > 5 and dirM < 175 
        last_dir_left_right = DIR.RIGHT;
	if dirM > 185 and dirM < 355 
        last_dir_left_right = DIR.LEFT;
}
