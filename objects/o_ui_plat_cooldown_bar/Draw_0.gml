if target == noone exit
depth = DEPTH_UI.MENU_UI - 2

draw_set_color(image_blend)
draw_set_alpha(image_alpha)
draw_set_font(loc_font("main"))
draw_set_halign(fa_center)
draw_set_valign(fa_bottom)
draw_text_scale(text, x, y, 0.5, image_blend, image_alpha)
draw_set_alpha(1)
draw_sprite_ext(spr_pixel, 0, x - (0.5 * barwidth), y, barwidth, 6, 0, image_blend, image_alpha);
draw_sprite_ext(spr_pixel, 0, (x - (0.5 * barwidth)) + 1, y + 1, barwidth - 2, 4, 0, c_black, image_alpha);
draw_sprite_ext(spr_pixel, 0, (x - (0.5 * barwidth)) + 2, y + 2, lerp(0, barwidth - 4, cooldown_timer / cooldown_timer_max), 2, 0, image_blend, image_alpha);
draw_set_color(c_white)
draw_set_halign(fa_left)
draw_set_valign(fa_top)