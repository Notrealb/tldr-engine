if !instance_exists(maker) exit
if !is_array(params) exit

matrix_set(matrix_world, matrix_build(maker.x, maker.y, 0, 0, 0, 0, 1, 1, 1));
if maker.lining_palette!=noone {
	var pal = maker.lining_palette
	var parr = maker.lining_palette_index_array
	var gpp = global.platforming_perspective
	var index = is_array(parr) ? lerp(parr[0], parr[1], gpp) : gpp * (sprite_get_width(pal) - 1)
	pal_swap_set(pal, index, false)
}

if is_callable(maker.lining_sprite_or_drawer) {
	// Feather ignore once GM1021
	maker.lining_sprite_or_drawer(params[0], params[1], params[2], params[3], params[4], params[5])
}
else if sprite_exists(maker.lining_sprite_or_drawer) {
	var spr = maker.lining_sprite_or_drawer
	draw_sprite_ext(spr, draw_get_subimg(spr), params[0], params[1], params[2] / sprite_get_width(spr), params[3], 0, params[4], params[5]);
}

matrix_reset();
pal_swap_reset();
/*
depth = -2000
var _list = ds_list_create();
var _num = collision_rectangle_list(maker.x, maker.y, maker.x + (params[2] * sprite_get_width(maker.sprite_index)), maker.y - 2, [o_pf_decor, o_actor], true, true, _list, false);

var _ia = [depth]
if (_num > 0) {
	for (var i = 0; i < _num; ++i) {
		array_push(_ia, _list[| i].depth)
	}
}
ds_list_destroy(_list);
//depth = array_min(_ia) - 1