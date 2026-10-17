cutscene_create()
cutscene_player_canmove(false)
cutscene_party_follow(false)
for (var i = 0; i < party_length(true); i ++) {
	var inst = party_get_inst(global.party_names[i])
	cutscene_set_variable(inst, "image_speed", 0)
}
cutscene_wait_until(function(){return !instance_exists(o_ui_plat_action)})
cutscene_player_canmove(true)
cutscene_party_follow(true)
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
best = noone
secondbest = noone

if instance_exists(o_eff_plataction_darken)
	instance_destroy(o_eff_plataction_darken)
overdraw_inst = instance_create(o_eff_plataction_darken)

il = function(st, en, va){
	if (va == st)
		return 0;
	return (va - st) / (en - st);	
}