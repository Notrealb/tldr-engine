cutscene_create()
cutscene_player_canmove(false)
cutscene_party_follow(false)
for (var i = 0; i < party_length(true); i ++) {
	var inst = party_get_inst(global.party_names[i])
	cutscene_set_variable(inst, "image_speed", 0)
}
cutscene_wait_until(function(){return !instance_exists(o_ui_plataction)})
cutscene_player_canmove(true)
cutscene_party_follow(true)
cutscene_play()

depth = DEPTH_UI.MENU_UI
_pcolor = c_white

selection_x = get_leader().x
selection_y = get_leader().y-17-clamp(get_leader().pf_final_ychange, 0, 7)
//if get_leader()