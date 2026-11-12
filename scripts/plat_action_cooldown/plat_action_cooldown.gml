function cooldownbar_create(_char, _text = -1, _time = 30*5) {
	var pinst = _char;//party_get_inst(global.party_names[_char]);
	var barinst = instance_create(o_ui_plat_cooldown_bar)
	barinst.target = pinst
	if variable_instance_exists(pinst, "pf_cooldown_bar_inst") and instance_exists(pinst.pf_cooldown_bar_inst) {
		instance_destroy(pinst.pf_cooldown_bar_inst)
	}
	pinst.pf_cooldown_bar_inst = barinst
	
	if _text != -1
		barinst.text = _text
	
	barinst.cooldown_timer = _time
	return barinst
}