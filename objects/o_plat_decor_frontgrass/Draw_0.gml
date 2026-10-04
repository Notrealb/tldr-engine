matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, 0, 1, 1, 1));
if palette!=noone {
	var pal = palette
	var parr = palette_index_array
	var gpp = global.platforming_perspective
	var index = is_array(parr) ? lerp(parr[0], parr[1], gpp) : gpp * (sprite_get_width(pal) - 1)
	pal_swap_set(pal, index, false)
}

if sprite_exists(sprite_or_drawer) {
	matrix_reset();
	sprite_index = sprite_or_drawer
	event_inherited();
}
else if is_callable(sprite_or_drawer) {
	// Feather ignore once GM1021
	sprite_or_drawer(__xoff, __yoff, image_xlength, 1, image_blend, image_alpha)
}

matrix_reset();
pal_swap_reset();
