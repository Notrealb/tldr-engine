function ex_misc_draw_grass(_x, _y, _w, _h, _blend, _alpha) {
	var index = o_world.frames * 0.2
	var spr_cen = spr_ex_ow_garden_grass_center;
	var spr___t = spr_ex_ow_garden_grass_top;
	var spr___l = spr_ex_ow_garden_grass_left;
	var spr___b = spr_ex_ow_garden_grass_bottom;
	var spr___r = spr_ex_ow_garden_grass_right;
	var spr__tl = spr_ex_ow_garden_grass_top_left;
	var spr__tr = spr_ex_ow_garden_grass_top_right;
	var spr__bl = spr_ex_ow_garden_grass_bottom_left;
	var spr__br = spr_ex_ow_garden_grass_bottom_right;
	
    var last_i = floor(_w/20);
    var last_j = floor(_h/20);
    
    for (var i = 0; i < _w/20; i += 1) {
        for (var j = 0; j < _h/20; j += 1) {
            var ww = min(i*20 + 20, _w) % 20;
            var hh = min(j*20 + 20, _h) % 20;
            
            if ww == 0 
                ww = 20;
            if hh == 0 
                hh = 20;
            
            var _sprite = spr_cen;
            
            if j == 0
                _sprite = spr___t;
            else if j == last_j
                _sprite = spr___b;
            
            if i == 0 && _sprite == spr_cen
                _sprite = spr___l;
            if i == 0 && _sprite == spr___t
                _sprite = spr__tl;
            if i == 0 && _sprite == spr___b
                _sprite = spr__bl;
            
            if i == last_i && _sprite == spr_cen
                _sprite = spr___r;
            if i == last_i && _sprite == spr___t
                _sprite = spr__tr;
            if i == last_i && _sprite == spr___b
                _sprite = spr__br;
            
			var img = cap_wraparound(index + (_x / 320) + (i * 0.125) + (j * 0.125) + (_y / 320), 7.999 + 10)
			if img >= 4
				img = 0
			
            draw_sprite_stretched_ext(_sprite, img, _x + (20 * i), _y + (20 * j), ww, hh, _blend, _alpha);
        }
    }
}
function ex_misc_draw_grass_lining_basic(_x, _y, _w, _h, _blend, _alpha) {
	var index = o_world.frames * 0.2
	var spr_lin = spr_ex_ow_garden_grass_lining_upper
	
	for (var i = 0; i < _w/20; i += 1) {
        var ww = min(i*20 + 20, _w) % 20;
        if ww == 0 
            ww = 20;
        
		var img = cap_wraparound(index + (_x / 320) + (i * 0.125) + (_y / 320), 7.999 + 10);
		if img >= 4
			img = 0;
		
        draw_sprite_ext(spr_lin, img, _x + (20 * i), _y, ww/20, 1, 0, _blend, _alpha);
    }
}
function ex_misc_draw_grass_lining_accurate(_x, _y, _w, _h, _blend, _alpha) {
	var index = o_world.frames * 0.2
	var spr_lin_upper = spr_ex_ow_garden_grass_lining_upper
	var spr_lin_lower = spr_ex_ow_garden_grass_lining_lower
	
	for (var i = 0; i < _w/20; i += 1) {
        var ww = min(i*20 + 20, _w) % 20;
        if ww == 0 
            ww = 20;
        
		var img = cap_wraparound(index + (_x / 320) + (i * 0.125) + (_y / 320), 7.999 + 0);
		if img >= 4
			img = 0;
		
        draw_sprite_ext(spr_lin_upper, img, _x + 0.5 + (20 * i), _y - 10, ww/20, 1, 0, _blend, _alpha);
        draw_sprite_ext(spr_lin_lower, img, _x + (20 * i), _y - 5, ww/20, 1, 0, _blend, _alpha);
    }
}