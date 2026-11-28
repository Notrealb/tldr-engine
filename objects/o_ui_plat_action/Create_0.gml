// If true, and the party has so many members that the recharging/ready text would normally
// continue off the screen, draw the ready text in a smaller overflow text position.
// If false, just cut off the ready text if needed.
__cfg_DrawOverflowDescriptionReadyText = false

cutscene_create()
cutscene_player_canmove(false)
for (var i = 0; i < party_length(true); i ++) {
	var inst = party_get_inst(global.party_names[i])
	cutscene_set_variable(inst, "image_speed", 0)
}
cutscene_wait_until(function(){return !instance_exists(o_ui_plat_action)})
cutscene_player_canmove(true)
cutscene_play()

depth = DEPTH_UI.MENU_UI
_pcolor = c_white

act_targets_array = []
act_target_index = noone
soul_origin_x = 0
soul_origin_y = 0
selection_x = 0
selection_y = 0
selection_inst = id
pressdir = 0
bestarray = []

if instance_exists(o_eff_plat_action_darken)
	instance_destroy(o_eff_plat_action_darken)
overdraw_inst = instance_create(o_eff_plat_action_darken)

if instance_exists(o_eff_plat_action_soul)
	instance_destroy(o_eff_plat_action_soul)
souldraw_inst = instance_create(o_eff_plat_action_soul)

il = function(st, en, va){
	if (va == st)
		return 0;
	return (va - st) / (en - st);	
}

__act_targets_array_do_node_search_and_add_to_bestarray = function(_angle, _dist = 9999, _dont_push_to_bestarray = false) {
	act_targets_array = [];
	for (var i = 0; i < instance_number(o_plat_action_node); ++i) {
		var inst = instance_find(o_plat_action_node, i);
		
		if plat_get_action_node_is_selectable(inst, selection_inst)
		and (_angle <= 0 or point_in_triangle(inst.x, inst.y,
			selection_x,
			selection_y,
			selection_x + lengthdir_x(_dist, pressdir - _angle),
			selection_y + lengthdir_y(_dist, pressdir - _angle),
			selection_x + lengthdir_x(_dist, pressdir + _angle),
			selection_y + lengthdir_y(_dist, pressdir + _angle)
		))
	        array_push(act_targets_array, inst);
	}
	
	if id != selection_inst
		array_push(act_targets_array, id);
	
	if !_dont_push_to_bestarray and array_length(act_targets_array) >= 1
		array_push(bestarray, instance_nth_nearest(selection_x, selection_y, act_targets_array, 1))
}

acts_are_available = false
even_though_acts_are_available_we_cant_select_because = []
but_there_are_available_acts_anyway_so_this_doesnt_matter = false

alivetime = 0
description_typer_inst = noone
__txt_desc_typer_make = function(_text) {
	if !instance_exists(description_typer_inst){
		description_typer_inst = text_typer_create(
			_text,
			20,
			(o_camera.height * 2) - 100 - (instance_exists(o_ui_menu) ? ((60 - 17) * o_ui_menu.menuroll) : 0) + 40,
			depth - 8,
			"{can_skip(false)}{voice(nil)}{auto_breaks(false)}* ",
			"{stop}", {
				gui: true,
				caller: o_ui_plat_action,
				destroy_caller: false
			}
		)
	}	
}

__txt_desc_typer_clear = function() {
	if instance_exists(description_typer_inst){
		instance_destroy(description_typer_inst);
		description_typer_inst = noone;
	}	
}

__extradraw_outline = function(extra, name, i, inst, xdelta, ydelta) {
	if global.party_names[i] == "ralsei" and instance_exists(o_eff_ralseihang)
		_pdrawer(extra.sprite_index, extra.image_index, 
			160 + xdelta - (inst.x - extra.x),
			120 + ydelta - (inst.y - extra.y),
			extra.image_xscale, extra.image_yscale,
			extra.image_angle, c_white, 1//image_alpha
		)
}

__extradraw_sprite = function(extra, name, i, inst, xx2, yy2) {
	if global.party_names[i] == "ralsei" and instance_exists(o_eff_ralseihang)
		_pdrawer(extra.sprite_index, extra.image_index, 
			xx2 - (inst.x - extra.x),
			yy2 - (inst.y - extra.y),
			extra.image_xscale, extra.image_yscale,
			extra.image_angle, c_white, 1//image_alpha
		)
}