image_angle = 0

var gpp = global.platforming_perspective;

// Create front grass lining
if inst_grass_front == -1 and front_grass_sprite_or_drawer != undefined {
	inst_grass_front = instance_create(o_pf_decor_frontgrass)
	inst_grass_front.wall_parent = self
	inst_grass_front.collide_ow = false
	inst_grass_front.collide_while_plat = false
	inst_grass_front.sprite_or_drawer = front_grass_sprite_or_drawer
	inst_grass_front.palette = lining_palette
	inst_grass_front.palette_index_array = lining_palette_index_array
}

// Create back grass lining
if inst_grass_back == -1 and back_grass_sprite_or_drawer != undefined {
	inst_grass_back = instance_create(o_pf_decor_backgrass)
	inst_grass_back.wall_parent = self
	inst_grass_back.collide_ow = false
	inst_grass_back.collide_while_plat = false
	inst_grass_back.sprite_or_drawer = back_grass_sprite_or_drawer
	inst_grass_back.palette = lining_palette
	inst_grass_back.palette_index_array = lining_palette_index_array
}

// Set Y
{__y_while_not_pf =
	ystart
	+ (tilesize * wall_y_offset_in_tiles_while_not_pf)
}
{__y_while_pf =
	ystart
	- (flatten_while_plat ? ((tilesize * (0 + wall_closeness_in_tiles)) * (1-((1-perspectiveangle)*gpp)) ) : (tilesize * wall_closeness_in_tiles))
	+ (tilesize * o_dev_pf_controller.all_additional_y_offset_in_tiles_while_pf)
	+ (tilesize * wall_y_offset_in_tiles_while_pf)
}
__y_lerp = lerp(__y_while_not_pf, __y_while_pf, (1-perspectiveangle)*gpp)
y = __y_lerp

// Collision
if gpp == 0 and solid_while_not_pf {collide = true} else {collide = false}
if gpp == 1 and solid_while_pf and use_pulpit_collision {
	var l = get_leader()
	if l.y<l.yprevious or place_meeting(x,y,l) {collide = false} else {collide = true}
} 
else if gpp == 1 and solid_while_pf {collide = true} else {collide = false}


// Alpha
if !visible_while_pf and !visible_while_not_pf {visible = false}
else if !visible_while_pf {image_alpha = 1-gpp}
else if !visible_while_not_pf {image_alpha = gpp}

// Depth
if o_dev_pf_controller.do_autodepthsort_walls
	depth = 0 + (-wall_closeness_in_tiles * tilesize * 100) + (ystart * 10);
else
	depth = 0 + (-wall_closeness_in_tiles * tilesize * 100);
if depth_override != undefined
	depth = depth_override;
