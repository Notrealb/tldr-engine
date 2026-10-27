event_inherited()

image_blend_start = image_blend

actnodes_alpha = 1

wall_parent = undefined

// Automatically set wall parent
call_later(1, time_source_units_frames, function(){
	if instance_exists(wall_parent_override)
		wall_parent = wall_parent_override;
	else if auto_get_wall_parent and !instance_exists(wall_parent) {
		var t = noone
		for (var i=0; i<=200 and t==noone; i+=1) {
			var c = collision_point(x, y+i, o_plat_wall, true, true); if c and !c.decor_should_not_pick_me {t = c}
		}
		if !instance_exists(t)
			show_debug_message("No wall_parent could be found for "+string(id)+".");
		else
			wall_parent = t;
	}
})


__calc_y_and_do_darken = function(__do_darken = true, __p = global.platforming_perspective){
	//var __do_darken = true
	//var __p = global.platforming_perspective
	var sy = y
	if use_y_from_wall_parent and instance_exists(wall_parent) and instance_exists(o_dev_plat_controller) {
		var abc_a = wall_parent.y - (wall_parent.floor_backlength_in_tiles * wall_parent.tilesize * (1-((1-max(wall_parent.perspectiveangle, 0.02))*__p)));
		var abc_s = wall_parent.__y_while_not_pf - (wall_parent.floor_backlength_in_tiles * wall_parent.tilesize);
		var def = (ystart - abc_s) / (wall_parent.__y_while_not_pf - abc_s);
		y = lerp(abc_a, wall_parent.y, def);
	
		var yco = 0
		if o_dev_plat_controller.all_walls_y_off_for_centering == "auto"
			yco = ((o_dev_plat_controller.player_floor_centering * o_dev_plat_controller.wall_generic_bltts) * (1-((1-wall_parent.perspectiveangle)*__p)))
		else
			yco = o_dev_plat_controller.all_walls_y_off_for_centering
	
		y = lerp(y, y + yco + o_dev_plat_controller.default_platformsdrawyoffset, __p);
	
		if __do_darken and darken > 0
			image_blend = merge_color(image_blend_start, darken_color, (1-def) * __p * clamp(darken, 0, 1));
	}
	else if !use_y_from_wall_parent and if_not_using_wall_parent_y_then_use_controller_perspectiveangle and instance_exists(o_dev_plat_controller) {
		y = ystart + ((1-o_dev_plat_controller.default_perspectiveangle)*__p*2)
	}
	var r = y
	y = sy
	return r
}