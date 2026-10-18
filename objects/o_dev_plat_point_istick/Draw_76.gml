if (variable_instance_exists(target_instance, "is_in_battle") and target_instance.is_in_battle)
	exit;

if target_instance and do_set_inst_depth {
	event_inherited()
	target_instance.depth = depth
}