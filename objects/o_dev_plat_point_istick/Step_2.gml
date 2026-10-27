if target_instance == undefined exit
if !is_array(target_instance) target_instance = [target_instance]

for (var i = 0; i < array_length(target_instance); i ++) {
	if !instance_exists(target_instance[i]) {
		instance_destroy();
	}
	else if (variable_instance_exists(target_instance[i], "is_in_battle") and target_instance[i].is_in_battle) {}
	else if instance_exists(target_instance[i]) {
		if do_set_inst_y {
			event_inherited()
			target_instance[i].y = y;
		}
		if do_set_inst_x
			target_instance[i].x = x;
	}
}