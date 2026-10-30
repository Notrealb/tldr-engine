function plat_create_action_node(
	_xcorrect = 0,
	_ycorrect = 0,
	_char = "susie",
	_effect = -1,
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
	_inst.effect = _effect;
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
}



