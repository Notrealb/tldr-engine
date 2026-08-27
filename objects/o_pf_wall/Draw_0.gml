if image_alpha <= 0 or !visible exit;

var testblend = image_blend//c_white//merge_color(image_blend, c_red, abs(wall_closeness_in_tiles)/4)

__y_after_offset = lerp(y, y + o_dev_pf_controller.default_platformsdrawyoffset, global.platforming_perspective)

var gpp = global.platforming_perspective;
var bltts = floor_backlength_in_tiles * tilesize;
if flatten_while_plat {bltts = lerp(floor_backlength_in_tiles, 2, gpp) * tilesize;}
var wal_width = image_xscale * sprite_get_width(sprite_index);
var wal_height = image_yscale * sprite_get_height(sprite_index);

// Draw the floor
var flr_spr = floor_use_next_wall_image_instead ? sprite_index : floor_sprite;
if sprite_exists(flr_spr) and floor_drawer!="nothing" and floor_backlength_in_tiles != 0 {
	matrix_set(matrix_world, matrix_build(x, __y_after_offset, 0, 0, 0, 0, 1, 1, 1));
	var flr_squish = (1-((1-perspectiveangle)*gpp))
	var flr_height = bltts * flr_squish;
	if floor_will_squish_with_matrix and !array_contains(["span"], floor_drawer){
		matrix_set(matrix_world, matrix_build(x, __y_after_offset, 0, 0, 0, 0, 1, (1-((1-perspectiveangle)*gpp)), 1));
		flr_height = bltts;
	}
	_pf_paletteswap_set(floor_palette, floor_palette_index_array)
	var flr_img = floor_use_next_wall_image_instead ? image_index+1 : draw_get_subimg(flr_spr);
	if floor_backlength_in_tiles > 0
	and !(gpp == 1 and perspectiveangle == 0)
	{
		if floor_drawer == undefined or floor_drawer == "matrixsquish"{
			var b = image_blend//merge_color(testblend, c_fuchsia, 0.5)
			draw_sprite_ext(flr_spr, flr_img, 0, -flr_height, wal_width/sprite_get_width(flr_spr), flr_height/sprite_get_height(flr_spr), 0, b, image_alpha);
		}
		else if floor_drawer == "span" { for (var i=0.5; i<=flr_height; i+=0.5) {
			var b = image_blend//merge_color(testblend, c_lime, 0.5)
			draw_sprite_ext(flr_spr, flr_img, 0, 0-i, wal_width/sprite_get_width(flr_spr), wal_height/sprite_get_height(flr_spr), 0, b, image_alpha);
		}}
		else if is_callable(floor_drawer) {
			var b = c_white
			// Feather ignore once GM1021
			floor_drawer(0, -flr_height, wal_width, flr_height, b, image_alpha);
		}
	}
}

// Draw the wall
matrix_set(matrix_world, matrix_build(x, __y_after_offset, 0, 0, 0, 0, 1, 1, 1));
_pf_paletteswap_set(wall_palette, wall_palette_index_array)
draw_sprite_ext(sprite_index, image_index, 0, 0, image_xscale, image_yscale, 0, testblend, image_alpha);

// Reset anything that needs to be reset
matrix_reset();
pal_swap_reset();

draw_text_scale(string(depth), x, __y_after_offset, 0.5, c_white, 0.4)
