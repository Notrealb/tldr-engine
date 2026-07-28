draw_sprite_stretched_ext(spr_pixel, 0, o_camera.x-60, o_camera.y-60, o_camera.width+120, o_camera.height+120, c_black, global.plataction_fade*0.5)

for (var i = party_length(true)-1; i > -1; i --) {
	var inst = party_get_inst(global.party_names[i])
	_pcolor = party_getdata(global.party_names[i], "color")
	_pdrawer = inst.s_drawer
	//with inst {
		plataction_outline_surf = -1
		var spr = inst.sprite_index
		if !sprite_exists(inst.sprite_index) 
		    spr = spr_default
		
		var xx = inst.x + inst.xoff + sine(.5, inst.shake)
		var yy = inst.y + inst.yoff + lerp(0, -2, global.platforming_perspective)
		if global.plataction_fade > 0 && inst.is_player { // outline and bg darkener
			if !surface_exists(plataction_outline_surf) // create outline surface
				plataction_outline_surf = surface_create(320, 240)
	
			surface_set_target(plataction_outline_surf) { // draw pulsing outline
				draw_clear_alpha(0, 0)
				gpu_set_fog(true, merge_color(c_black, _pcolor, 0.5+sine(5, 0.25)), 0, 0)
				//gpu_set_fog(true, merge_color(_pcolor, c_white, 0.5+sine(5, 0.25)), 0, 0) //when selected
	
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
	
			draw_surface_ext(plataction_outline_surf, xx - 160, yy - 120, 1, 1, 0, c_white, global.plataction_fade)
		}
		
		// draw the sprite
		_pdrawer(spr, inst.image_index, 
			xx, yy, 
			inst.image_xscale, inst.image_yscale, 
			inst.image_angle, c_white, global.plataction_fade//image_alpha * alpha_mod
		)
	//}
}

draw_sprite_ext(spr_soul, 0, selection_x, selection_y, 0.5, 0.5, 0, c_white, 1)
