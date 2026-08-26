event_inherited();

image_index = irandom(image_number);
image_speed = choose(0.15, 0.18, 0.21, 0.24);
//hp = 0.5;

// Particle depth
_particle_depth = depth - 1;
call_later(2, time_source_units_frames, function(){
	if instance_exists(wall_parent) {
		var wt = wall_parent;
		var bltts = (wt.floor_backlength_in_tiles * wt.tilesize);
		_particle_depth = wt.depth - (bltts * 2) - 1;
	}
})
