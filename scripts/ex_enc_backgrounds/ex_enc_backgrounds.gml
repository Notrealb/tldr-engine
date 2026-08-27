function ex_enc_background_colorable_grid(_color = #420042, _sprite = spr_enc_bg, _image = -1, _scale_x = 1, _scale_y = 1) : enc_background() constructor {
    color = _color;
    sprite = _sprite;
	image = -1;
    scale_x = _scale_x;
    scale_y = _scale_y;
    
	bg_draw_content = function() {
        surface_set_target(bg_surf);
            draw_clear_alpha(0, 0);
            
    		var siner = o_world.frames / 2;
    		var siner2 = o_world.frames;
			var img = image
			if img == -1
				img = draw_get_subimg(sprite)
    		draw_sprite_tiled_ext(sprite, img, -50 + siner, -50 + siner, scale_x, scale_y, merge_color(c_black, color, 0.5), 1);
    		draw_sprite_tiled_ext(sprite, img, -100 - siner2, -105 - siner2, scale_x, scale_y, color, 1);
        surface_reset_target();
	}
}
function ex_enc_background_spawnlings() : enc_background() constructor {
    color = merge_colour(c_red, c_black, 160/255);
    
	bg_draw_content = function() {
        surface_set_target(bg_surf);
            draw_clear_alpha(0, 0);
            
    		var siner = o_world.frames / 2;
    		var siner2 = o_world.frames;
            
            draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, color, 1);
            
    		draw_sprite_tiled_ext(spr_enc_bg, 0, -50 + siner + sine(16, 10, o_world.frames + 16), -50 + siner + cosine(16, 10, o_world.frames + 16), 1, 1, color, 1);
    		draw_sprite_tiled_ext(spr_ex_enc_bg_spawnlings, 0, -100 - siner2 + sine(20, 12), -105 - siner2 + cosine(20, 12), 1, 1, color, .5);
        
            draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, .7);
        
    		draw_sprite_tiled_ext(spr_enc_bg, 0, -60 + siner + sine(16, 40, o_world.frames + 8), -60 + siner + cosine(16, 40, o_world.frames + 8), 1, 1, color, .75);
    		draw_sprite_tiled_ext(spr_enc_bg, 0, -50 + siner + sine(16, 20, o_world.frames + 16), -50 + siner + cosine(16, 20, o_world.frames + 16), 1, 1, color, 1);
        surface_reset_target();
	}
}

function ex_enc_bulletdark_drawtiled(_color = #420042, _sprite = o_enc_target, _image = -1, _scale_x = 1, _scale_y = 1, _alpha = 1, _clear_alpha = 0.75) : enc_bulletdark() constructor {
	bg_bulletdark_clear_alpha = _clear_alpha;
    alpha = _alpha;

	color = _color;
    sprite = _sprite;
	image = -1;
    scale_x = _scale_x;
    scale_y = _scale_y;
    
	bulletdark_draw_content = function() {
        surface_set_target(bulletdark_surf);
            draw_clear_alpha(0, 0);
            
    		var siner = o_world.frames / 2;
    		var siner2 = o_world.frames;
			var img = image
			if img == -1
				img = draw_get_subimg(sprite)
    		draw_sprite_tiled_ext(sprite, img, -50 + siner, -50 + siner, scale_x, scale_y, merge_color(c_black, color, 0.5), alpha);
    		draw_sprite_tiled_ext(sprite, img, -100 - siner2, -105 - siner2, scale_x, scale_y, color, alpha);
        surface_reset_target();
	}
}