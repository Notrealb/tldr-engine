

// draw the node
if vis {
	var dmalpha = global.platforming_perspective
	if instance_exists(host) and variable_instance_exists(host, "actnodes_alpha")
		dmalpha *= host.actnodes_alpha;
	if draw_myself
		draw_sprite_ext(sprite_index, image_index, x-.5, y-.5, image_xscale, image_yscale, image_angle, image_blend, dmalpha);
	
	var _alpha = dmalpha * alpha * image_alpha;
	
	var aa = lerp(angle, (((floor(angle / 90) % 4) * 90) + 45) - (45 * 1), hoverlerp);
	
	var ncol = node_color;
	if protected
		ncol = c_yellow;
	else if superblocked
		ncol = make_color_hsv((((current_time * 0.005) / 14) * 255) % 255, 255, 255);
	
	if superblocked or blocked or protected or char_in_cooldown
		draw_sprite_ext(spr_plat_targetmode_cross, 0, x, y, 1, 1, 0, ncol, alpha);
	else {
		draw_sprite_ext(spr_plat_targetmode_circle, 0, x, y, 1, 1, 0, ncol, alpha);
		draw_sprite_ext(spr_plat_targetmode_reticle, hoverlerp * 7, x, y, .5, .5, aa, ncol, alpha);
	}
}
