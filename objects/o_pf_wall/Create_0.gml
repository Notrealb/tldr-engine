event_inherited();
if !instance_exists(o_dev_pf_controller) {instance_create_depth(-100, -100, depth, o_dev_pf_controller)};
if tilesize == -1 {tilesize = o_dev_pf_controller.default_tilesize};
if perspectiveangle == -1 {perspectiveangle = o_dev_pf_controller.default_perspectiveangle};

__y_while_not_pf = -1
__y_while_pf = -1
__y_lerp = -1

/*

 --- variable documentation ---

solid_while_pf
	Is solid while platforming?

solid_while_not_pf
	Is solid while not platforming?

use_pulpit_collision
	Create an _external_ object at the floor which can be jumped up through.

visible_while_pf
	Is visible while platforming?

visible_while_not_pf
	Is visible while not platforming?

wall_closeness_in_tiles
	Closeness to 'camera' / point of vision, measured in given tile size.

wall_y_offset_in_tiles_while_not_pf
	Y offset while not platforming, measured in given tile size.

floor_backlength_in_tiles
	Length of floor to draw above/behind the wall, measured in given tile size.

floor_flatten_while_plat
	While platforming, align the 'closeness' to the position that'd be the 'top' of the floor.

floor_sprite
	Sprite of floor.
	
floor_use_next_image_instead
	Use the next image from the current image_index of sprite_index, the wall, as the floor sprite instead?

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

tilesize
	Size of tiles. Controlled by o_dev_pf_controller, although a custom value can be given here.
	
perspectiveangle
	Perspective angle. Controlled by o_dev_pf_controller, although a custom value can be given here.
*/