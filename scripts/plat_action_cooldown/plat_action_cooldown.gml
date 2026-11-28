function cooldownbar_create(_char, _text = "", _frames = 30*5) {
	var pinst = is_string(_char) ? party_get_inst(_char) : _char;//;
	var barinst = instance_create(o_ui_plat_cooldown_bar)
	barinst.target = pinst
	if variable_instance_exists(pinst, "pf_cooldown_bar_inst") and instance_exists(pinst.pf_cooldown_bar_inst) {
		instance_destroy(pinst.pf_cooldown_bar_inst)
	}
	pinst.pf_cooldown_bar_inst = barinst
	
	if _text != ""
		barinst.text = _text
	
	barinst.cooldown_framesr = _frames
	return barinst
}