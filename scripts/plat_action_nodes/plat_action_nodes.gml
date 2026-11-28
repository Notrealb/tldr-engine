function plat_create_action_node(
	_xcorrect = 0,
	_ycorrect = 0,
	_char = "susie",
	_host_effect = -1,
	_node_effect = -1,
	_action_override = -1,
	_ui_header_override = -1,
	_ui_description_override = -1,
	_active = true,
	_blocked = false,
	_superblocked = false,
	_protected = false,
	_destroy_when_host_missing = true,
	_depthcorrect = -10,
	_node_color = -1,
	_bwoosh_color = -1,
	_bwoosh_method = -1,
	
	_inst = instance_create(o_plat_action_node),
	_host = self
) {
	//inst = _inst;
	_inst.host = _host;
	
	_inst.xcorrect = _xcorrect;
	_inst.ycorrect = _ycorrect;
	_inst.char = _char;
	_inst.host_effect = _host_effect;
	_inst.node_effect = _node_effect;
	_inst.action_override = _action_override;
	_inst.ui_header_override = _ui_header_override;
	_inst.ui_description_override = _ui_description_override;
	_inst.active = _active;
	_inst.blocked = _blocked;
	_inst.superblocked = _superblocked;
	_inst.protected = _protected;
	_inst.destroy_when_host_missing = _destroy_when_host_missing;
	_inst.depthcorrect = _depthcorrect;
	_inst.node_color = _node_color;
	_inst.bwoosh_color = _bwoosh_color;
	_inst.bwoosh_method = _bwoosh_method;
	
	return _inst
}

function plat_get_action_node_is_selectable(inst, selection_inst = noone, _show_regardless_of_cooldown = false){
	var coolingdown = false
	for (var c = 0; c < instance_number(o_ui_plat_cooldown_bar); c++) {
		if party_get_inst(inst.char) == instance_find(o_ui_plat_cooldown_bar, c).target
			coolingdown = true;
	}
	
	if onscreen(inst, -6, undefined, true)
	and party_contains(inst.char, true)
	and inst != selection_inst
	and (!coolingdown or _show_regardless_of_cooldown)
	and inst.active
	and !inst.in_use
	and !inst.blocked
	and !inst.superblocked
	and !inst.protected
		return true;
	else
		return false;
}