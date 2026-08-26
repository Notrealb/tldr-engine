event_inherited()

// Automatically set wall parent
if !instance_exists(wall_parent) {
	var t = noone
	for (var i=0; i<=200 and t==noone; i+=1) {
		var c = collision_point(x, y+i, o_pf_wall, true, true); if c {t = c}
	}
	if !instance_exists(t) {
		show_debug_message("No wall_parent could be found for "+string(id)+".")
	}else{
		wall_parent = t
	}
}
