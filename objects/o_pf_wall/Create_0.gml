event_inherited();

if !instance_exists(o_dev_pf_controller)
	instance_create_depth(-100, -100, depth, o_dev_pf_controller);
if tilesize == -1
	tilesize = o_dev_pf_controller.default_tilesize;
if perspectiveangle == -1
	perspectiveangle = o_dev_pf_controller.default_perspectiveangle;

__y_while_not_pf = -1;
__y_while_pf = -1;
__y_lerp = -1;
__y_after_offset = -1;

inst_grass_front = -1;
inst_grass_back = -1;

_pf_paletteswap_set = function(_p_sprite, _p_array, _gpp = global.platforming_perspective){
	if _p_sprite!=noone {
		var index = is_array(_p_array) ? lerp(_p_array[0], _p_array[1], _gpp) : _gpp * (sprite_get_width(_p_sprite) - 1)
		pal_swap_set(_p_sprite, index, false)
	}
}

if use_pulpit_collision {
	solid_while_pf = false
	with instance_copy(false) {
		solid_while_pf = true
		sprite_index = spr_pf_pulpit_mask
		image_xscale = (other.image_xscale * sprite_get_width(other.sprite_index)) / sprite_get_width(sprite_index)
		floor_drawer = "nothing"
		visible = false
		image_alpha = 0
	}
}
/*

 --- variable documentation --- (to-update)

Collision -------

	solid_while_pf
		Is solid while platforming?
		
	solid_while_not_pf
		Is solid while not platforming?
		
	use_pulpit_collision
		Create an _external_ object at the floor which can be jumped up through.

Positioning -------

	wall_closeness_in_tiles
		Closeness to 'camera' / point of vision, measured in given tile size.
		Positive is closer. Negative is further away.

	wall_y_offset_in_tiles_while_not_pf
		Y offset while not platforming, measured in given tile size.

	floor_backlength_in_tiles
		Length of floor to draw above/behind the wall, measured in given tile size.

	floor_flatten_while_plat
		While platforming, align the 'closeness' to the position that'd be the 'top' of the floor.


Visual -------

	visible_while_pf
		Is visible while platforming?
		
	visible_while_not_pf
		Is visible while not platforming?
		
	floor_sprite
		Sprite of floor.
		
	floor_use_next_wall_image_instead
		Use the next image from the current image_index of sprite_index (the wall sprite) as the floor sprite instead?

	floor_drawer
		Floor drawing method.
			undefined
				Default setting. Draws the floor sprite.
			"span"
				Draws the floor sprite as if it were the wall repeatedly until the space is filled.
				Useful for simple slopes. For easy organization, setting floor_use_next_image_instead
				to true is recommended in that case.
			"nothing"
				Don't draw a floor.
			Any other input will run as if it were a function that exists.
	
	floor_will_squish_with_matrix
		Use a matrix to squish the floor while in platforming mode?
		Default true. Allows the use of 9-slicing, among various other things.
		If false, the sprite will be directly scaled instead.
	
	lining_sprite_or_drawer
		Lining sprite or drawing method. Sprite or function. If undefined, no lining will exist.
		
	lining_at_back_also
		Draw lining at the back of the floor also? Default true.
	
	lining_y_offset
		Lining y offset. Default 4.5
	
	wall_palette
	floor_palette
	lining_palette
		Palletes for the wall (sprite_index), floor (floor_sprite), and lining (lining_sprite_or_drawer).
	
	wall_palette_index_array
	floor_palette_index_array
	lining_palette_index_array
		Array of two indexes which these palettes will move between while in platforming mode.
		If undefined or not an array, the entire palette will used.


Controller Overrides --

	tilesize
		Size of tiles. Controlled by o_dev_pf_controller, although a custom value can be given here.
		
	perspectiveangle
		Perspective angle. Controlled by o_dev_pf_controller, although a custom value can be given here.


*/