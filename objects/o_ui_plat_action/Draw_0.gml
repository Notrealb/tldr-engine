var xx = soul_origin_x
var yy = soul_origin_y
var cx = selection_x
var cy = selection_y

var col = selection_inst.image_blend

//party outline
for (var i = party_length(true)-1; i > -1; i --) {
	var inst = party_get_inst(global.party_names[i])
	_pcolor = party_getdata(global.party_names[i], "color")
	_pdrawer = inst.s_drawer

	plataction_outline_surf = -1
	var spr = inst.sprite_index
	if !sprite_exists(inst.sprite_index) 
		spr = spr_default
	
	var im_acting = (_pcolor == selection_inst.image_blend)
	var havent_selected_yet = selection_inst == id
	
	var xx2 = inst.x + inst.xoff + sine(.5, inst.shake)
	var yy2 = inst.y + inst.yoff
	if global.plataction_fade > 0 && ((im_acting and !havent_selected_yet) or (havent_selected_yet and inst == get_leader())) { // outline and bg darkener
		xx = xx2
		yy = yy2 - 16
		if !surface_exists(plataction_outline_surf) // create outline surface
			plataction_outline_surf = surface_create(320, 240)
	
		surface_set_target(plataction_outline_surf) { // draw pulsing outline
			draw_clear_alpha(0, 0)
			gpu_set_fog(true, merge_color(_pcolor, c_white, 0.5+sine(5, 0.25)), 0, 0)
			if havent_selected_yet
				gpu_set_fog(true, merge_color(c_black, _pcolor, 0.5+sine(5, 0.25)), 0, 0)
			
			for (var j = 0; j < 360; j += 90) {
				var xdelta = lengthdir_x(1, j)
				var ydelta = lengthdir_y(1, j)
			
				_pdrawer(spr, inst.image_index, 
					160 + xdelta, 120 + ydelta,
					inst.image_xscale, inst.image_yscale,
					inst.image_angle, c_white, 1//image_alpha
				)
			}
		
			gpu_set_fog(false, c_white, 0, 0)
		}
		surface_reset_target()
	
		draw_surface_ext(plataction_outline_surf, xx2 - 160, yy2 - 120, 1, 1, 0, c_white, global.plataction_fade)
	}
		
	// draw the sprite
	_pdrawer(spr, inst.image_index, 
		xx2, yy2, 
		inst.image_xscale, inst.image_yscale, 
		inst.image_angle, c_white, global.plataction_fade//image_alpha * alpha_mod
	)
}

var size = 0.5;

if selection_inst != id {
	//Arrowline
	var j1 = 10
	var j2 = 20
	var dist = point_distance(xx, yy, cx, cy);
	var dir = point_direction(xx, yy, cx, cy);
	var wavefreq = current_time * -0.005;
	var dist_off = (current_time * 0.01) % j1;
        
	for (var i = j1; i < (dist - j1); i += j1)
	{
		var _idist = i + dist_off;
		var _x = lengthdir_x(_idist, dir);
		var _y = lengthdir_y(_idist, dir);
		var _alpha = 1;
	    
		if (_idist < j2)
			_alpha = il(j1, j2, _idist);
		else if (_idist > (dist - j2))
			_alpha = il(dist - j1, dist - j2, _idist);
		
		var _alpha2 = clamp(_alpha - (dist_off / j1), 0, 1) / 3;
		_idist += (dist_off * 0.75);
		var _x2 = lengthdir_x(_idist, dir);
		var _y2 = lengthdir_y(_idist, dir);
		draw_sprite_ext(spr_plat_targetmode_arrow, 0, xx + _x2, yy + _y2, size, size, dir, col, _alpha2);
		draw_sprite_ext(spr_plat_targetmode_arrow, 0, xx + _x, yy + _y, size, size, dir, col, _alpha);
	}
}

//soul
draw_sprite_ext(spr_soul, 0, selection_x, selection_y, 0.5, 0.5, 0, c_red, 1)