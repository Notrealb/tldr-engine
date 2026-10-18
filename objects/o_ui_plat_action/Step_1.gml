for (var h = 0; h < array_length(global.HITSTOP_OBJECTS); h ++) {
	if instance_exists(global.HITSTOP_OBJECTS[h]) and variable_instance_exists(global.HITSTOP_OBJECTS[h], "hitstop")
		global.HITSTOP_OBJECTS[h].hitstop = max(global.HITSTOP_OBJECTS[h].hitstop, 3);
}