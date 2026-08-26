if instance_exists(wall_parent)
	__ystartoverride = wall_parent.ystart - (wall_parent.tilesize * wall_parent.floor_backlength_in_tiles);
event_inherited();

