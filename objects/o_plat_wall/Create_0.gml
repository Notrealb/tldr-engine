event_inherited();

if !instance_exists(o_dev_plat_controller)
	instance_create_depth(-100, -100, depth, o_dev_plat_controller);
if tilesize == -1
	tilesize = o_dev_plat_controller.default_tilesize;
if perspectiveangle == -1
	perspectiveangle = o_dev_plat_controller.default_perspectiveangle;

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

pulpit_copy_inst = noone
is_the_made_pulpit_copy_inst = false
