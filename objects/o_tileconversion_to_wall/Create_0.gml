debug = false

saved_sprite_index = sprite_index
saved_x            = x
saved_y            = y
saved_image_xscale = image_xscale
saved_image_yscale = image_yscale

reset_params_from_saved = function(){
	sprite_index = saved_sprite_index
	x            = saved_x	
	y            = saved_y	
	image_xscale = saved_image_xscale	
	image_yscale = saved_image_yscale
}

var sw = sprite_get_width(saved_sprite_index)  // the tileconversion sprite width should always be the same as the tile size.
var sh = sprite_get_height(saved_sprite_index)

var failure = false
if image_xscale == 0
or string_ends_with(string(sprite_index), "_bt0") and image_yscale == 0
{
	failure = true
	instance_destroy()
}
if failure exit

tc_floor_params = 0
if !string_ends_with(string(sprite_index), "_bt0") {
	sprite_index    = spr_default_alt_1
	y			    = y - (sh * image_yscale)
	image_yscale    = ((sh - sw) / sw)
	tc_floor_params = __generate_tile_sprite(tile_layer)
}
reset_params_from_saved()

tc_wall_params = 0
if saved_image_yscale >= 1 {
	sprite_index   = spr_default_alt_1
	y			   = y - (sh * image_yscale) + (sh - sw)
	image_yscale   = (((sh * image_yscale) - (sh - sw)) / sw)
	tc_wall_params = __generate_tile_sprite(tile_layer)
}
reset_params_from_saved()


if tc_floor_params != 0 or tc_wall_params != 0 {
	var inst_wall = instance_create(o_plat_wall)
	if string_ends_with(string_delete(string(sprite_index), -1, 1), "_bt")
		inst_wall.floor_backlength_in_tiles = real(string_copy(string(sprite_index), string_length(string(sprite_index)), 1))
	else if string_ends_with(string_delete(string(sprite_index), -1, 2), "_bt")
		inst_wall.floor_backlength_in_tiles = real(string_copy(string(sprite_index), string_length(string(sprite_index)), 1))
	inst_wall.wall_closeness_in_tiles = wall_closeness_in_tiles
	inst_wall.solid_while_pf          = solid_while_pf
	inst_wall.solid_while_not_pf      = solid_while_not_pf
	inst_wall.use_pulpit_collision    = use_pulpit_collision
	inst_wall.use_pulpit_mask_also    = use_pulpit_mask_also
	
	
	if tc_wall_params != 0
		inst_wall.sprite_index = tc_wall_params[0]
	else {
		inst_wall.sprite_index = tc_floor_params != 0 ? tc_floor_params[0] : spr_default_alt_1
		inst_wall.do_draw_wall = false
	}
	
	if tc_floor_params != 0
		inst_wall.floor_sprite = tc_floor_params[0]
	else
		inst_wall.floor_drawer = "dont"
	
	inst_wall.x = tc_wall_params != 0 ? tc_wall_params[2] : tc_floor_params[2]
	inst_wall.xstart = inst_wall.x							
	inst_wall.y = tc_wall_params != 0 ? tc_wall_params[3] : tc_floor_params[3] + tc_floor_params[7]
	inst_wall.ystart = inst_wall.y
	//inst_wall.depth = 0
	//inst_wall.image_blend = c_lime
}

if !keep_after_making
	instance_destroy()