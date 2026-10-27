for (var h = 0; h < array_length(global.HITSTOP_OBJECTS); h ++) {
	if instance_exists(global.HITSTOP_OBJECTS[h]) and variable_instance_exists(global.HITSTOP_OBJECTS[h], "hitstop_timer")
		global.HITSTOP_OBJECTS[h].hitstop_timer = max(global.HITSTOP_OBJECTS[h].hitstop_timer, 3);
}