if image_alpha <= 0 or !visible exit;

var testblend = merge_color(image_blend, c_red, abs(wall_closeness_in_tiles)/4)

var flr_spr = floor_use_next_image_instead ? sprite_index : floor_sprite;
if !sprite_exists(flr_spr) {flr_spr = spr_default};
var flr_img = floor_use_next_image_instead ? image_index+1 : draw_get_subimg(flr_spr);

var gpp = global.platforming_perspective;
var bltts = floor_backlength_in_tiles * tilesize;
if flatten_while_plat {bltts = lerp(floor_backlength_in_tiles, 2, gpp) * tilesize;}
var wal_width = image_xscale * sprite_get_width(sprite_index);
var wal_height = image_yscale * sprite_get_width(sprite_index);
var flr_height = bltts * (1-((1-perspectiveangle)*gpp));
var p

// Set matrix
matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, 0, 1, 1, 1));
//if o_dev_pf_controller.palette_sprite != noone {o_dev_pf_controller.pal_start()}

// Floor draw
p = (floor_palette!=noone ? floor_palette : (o_dev_pf_controller.all_floor_palette!=noone ? o_dev_pf_controller.all_floor_palette : noone))
if p!=noone pal_swap_set(p, gpp * (sprite_get_width(p) - 1), false)
if floor_backlength_in_tiles > 0
and floor_drawer!="nothing"
and !(gpp == 1 and perspectiveangle == 0)
{
	if floor_drawer == undefined {
		var b = merge_color(testblend, c_fuchsia, 0.5)
		draw_sprite_ext(flr_spr, flr_img, 0, -flr_height, wal_width/sprite_get_width(flr_spr), flr_height/sprite_get_height(flr_spr), 0, b, image_alpha);
	}
	else if floor_drawer == "span" { for (var i=0.5; i<=flr_height; i+=0.5) {
		var b = merge_color(testblend, c_lime, 0.5)
		draw_sprite_ext(flr_spr, flr_img, 0, 0-i, wal_width/sprite_get_width(flr_spr), wal_height/sprite_get_height(flr_spr), 0, b, image_alpha);
	}}
	else if is_callable(floor_drawer) {
		var b = c_white
		// Feather ignore once GM1021
		floor_drawer(0, -flr_height, wal_width, flr_height, b, image_alpha);
	}
}
pal_swap_reset();

// Wall draw
p = (wall_palette!=noone ? wall_palette : (o_dev_pf_controller.all_wall_palette!=noone ? o_dev_pf_controller.all_wall_palette : noone))
if p!=noone pal_swap_set(p, gpp * (sprite_get_width(p) - 1), false)
draw_sprite_ext(sprite_index, image_index, 0, 0, image_xscale, image_yscale, 0, testblend, image_alpha);
pal_swap_reset();

// Reset matrix
matrix_reset();
//if o_dev_pf_controller.palette_sprite != noone {o_dev_pf_controller.pal_stop()}


