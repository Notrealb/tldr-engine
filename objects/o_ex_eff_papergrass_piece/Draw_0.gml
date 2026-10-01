var xscale_mod = dsin(siner_xscale);
var yscale_mod = dsin(siner_yscale);
var angle_mod = siner_angle;

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * xscale_mod, image_yscale * yscale_mod, image_angle + angle_mod, image_blend, image_alpha);