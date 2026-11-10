var gpp = global.platforming_perspective

// Collision
if gpp == 0
	collide = solid_while_not_pf ? true : false
if gpp == 1 {
	if solid_while_pf and use_pulpit_collision {
		var l = get_leader()
		collide = l.y<l.yprevious or place_meeting(x,y,l) ? false : true
	}
	else
		collide = solid_while_pf ? true : false
}


if !instance_exists(head) {
	head = instance_create(o_eff_ralseihanghead)
}
