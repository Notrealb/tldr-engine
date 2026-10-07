if InputPressed(INPUT_VERB.SELECT) {
	for (var i = 0; i < party_length(true); ++i) {
		var pinst = party_get_inst(global.party_names[i]);
		var barinst = instance_create(o_ui_plat_cooldown_bar)
		barinst.target = pinst
		if variable_instance_exists(pinst, "pf_cooldown_bar_inst") and instance_exists(pinst.pf_cooldown_bar_inst) {
			instance_destroy(pinst.pf_cooldown_bar_inst)
		}
		pinst.pf_cooldown_bar_inst = barinst
	}
}





if !InputCheck(INPUT_VERB.SPECIAL)
	instance_destroy();
	
