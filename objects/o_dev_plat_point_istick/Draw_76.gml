if target_instance == undefined exit
if do_set_inst_depth for (var i = 0; i < array_length(target_instance); i ++) {
	if (variable_instance_exists(target_instance[i], "is_in_battle") and target_instance[i].is_in_battle) {}
	else {
		if i == 0
			event_inherited();
		target_instance[i].depth = depth
		
	}
}