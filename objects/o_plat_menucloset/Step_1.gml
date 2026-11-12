event_inherited()

if open and !instance_exists(o_ui_menu) and !instance_exists(o_ui_menu_lw) {
	open = false;
	audio_play(close_sound);
}

sprite_index = global.platforming_perspective >= .5 ? spr_ow_menucloset_plat : spr_ow_menucloset
image_index = open ? 5 : 0;

if open {
	var l = get_leader()
	if variable_instance_exists(l, "pf_hmove")
		l.pf_hmove = 0;
	if variable_instance_exists(l, "pf_final_xchange")
		l.pf_final_xchange = 0;
}

if instance_exists(o_dodge_controller) and o_dodge_controller.dodge_mode == true
	node.blocked = true;
else
	node.blocked = false;