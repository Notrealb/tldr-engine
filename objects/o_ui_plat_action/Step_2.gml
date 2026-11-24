/*if InputPressed(INPUT_VERB.SELECT) { //test cooldown bar
	for (var i = 0; i < party_length(true); ++i) {
		var pinst = party_get_inst(global.party_names[i]);
		var barinst = instance_create(o_ui_plat_cooldown_bar)
		barinst.target = pinst
		if variable_instance_exists(pinst, "pf_cooldown_bar_inst") and instance_exists(pinst.pf_cooldown_bar_inst) {
			instance_destroy(pinst.pf_cooldown_bar_inst)
		}
		pinst.pf_cooldown_bar_inst = barinst
	}
}*/

alivetime++

if !global.player_moveable_global {
	instance_destroy();
}
else if !InputCheck(INPUT_VERB.SPECIAL) {
	if selection_inst
	and selection_inst.object_index == o_plat_action_node
	and selection_inst.selected
	and !party_getdata(selection_inst.char, "s_override") {
		audio_play(snd_plat_act_select);
		selection_inst.hoverlerp = 0;
		selection_inst.alpha = 0;
		if is_callable(selection_inst.action_override)
			selection_inst.action_override();
		else if is_callable(party_getdata(selection_inst.char, "plataction_default_action"))
			party_getdata(selection_inst.char, "plataction_default_action")();
		if is_callable(selection_inst.host_effect) and instance_exists(selection_inst.host)
			with selection_inst {with host other.host_effect()};
		if is_callable(selection_inst.node_effect)
			with selection_inst node_effect();
	}
	__txt_desc_typer_clear();
	instance_destroy();
}

if instance_exists(souldraw_inst) {
	souldraw_inst.x = selection_x;
	souldraw_inst.y = selection_y;
}