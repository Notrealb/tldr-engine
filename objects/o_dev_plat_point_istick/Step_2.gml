if !instance_exists(target_instance) {
	instance_destroy();
	exit;
}

if (variable_instance_exists(target_instance, "is_in_battle") and target_instance.is_in_battle)
	exit;

if target_instance {
	if do_set_inst_y {
		event_inherited()
		target_instance.y = y
	}
	if do_set_inst_x
		target_instance.x = x
}