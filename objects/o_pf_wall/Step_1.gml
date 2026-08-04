image_angle = 0

var gpp = global.platforming_perspective;



// Set Y
{__y_while_not_pf =
	ystart
	+ (tilesize * wall_y_offset_in_tiles_while_not_pf)
}
{__y_while_pf =
	ystart
	-(
		flatten_while_plat ? (
				(tilesize * (floor_backlength_in_tiles + wall_closeness_in_tiles))
				+ ((tilesize * (floor_backlength_in_tiles + wall_closeness_in_tiles)) * (1-((1-perspectiveangle)*gpp)) )
			)
		: (tilesize * wall_closeness_in_tiles)
	)
	+ (tilesize * o_dev_pf_controller.all_additional_y_offset_in_tiles_while_pf)
	+ (tilesize * wall_y_offset_in_tiles_while_not_pf)
}
__y_lerp = lerp(__y_while_not_pf, __y_while_pf, (1-perspectiveangle)*gpp)
y = __y_lerp

// Collision
if gpp == 0 and solid_while_not_pf {collide = true} else {collide = false}
if gpp == 1 and solid_while_pf and !use_pulpit_collision {collide = true} else {collide = false}
if !visible_while_pf and !visible_while_not_pf {visible = false}
