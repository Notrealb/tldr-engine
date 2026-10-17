var vL = INPUT_VERB.LEFT
var vR = INPUT_VERB.RIGHT
var vU = INPUT_VERB.UP
var vD = INPUT_VERB.DOWN
if InputCheckMany([vU, vD, vL, vR]) {
	pressdir = InputDirection(pressdir, INPUT_CLUSTER.DIRECTION)
}

var l = get_leader()
soul_origin_x = l.x
soul_origin_y = l.y - 16
x = soul_origin_x
y = soul_origin_y
var selection_x_prev = selection_x
var selection_y_prev = selection_y
if selection_inst == id {
	selection_x = x
	selection_y = y
} else {
	selection_x = selection_inst.x
	selection_y = selection_inst.y
}

act_targets_array = [];
for (var i = 0; i < instance_number(o_eff_plataction_target); ++i) {
	var ang = 35
	var dist = 9999
	var inst = instance_find(o_eff_plataction_target, i);
	if inst != selection_inst
	and onscreen(inst, 5, undefined, true)
	and point_in_triangle(inst.x, inst.y,
		selection_x,
		selection_y,
		selection_x + lengthdir_x(dist, pressdir - ang),
		selection_y + lengthdir_y(dist, pressdir - ang),
		selection_x + lengthdir_x(dist, pressdir + ang),
		selection_y + lengthdir_y(dist, pressdir + ang)
	)
        array_push(act_targets_array, inst);
}
if id != selection_inst
	array_push(act_targets_array, id);
	
best = array_length(act_targets_array) >= 1 ? instance_nth_nearest(selection_x, selection_y, act_targets_array, 1) : noone

act_targets_array = [];
for (var i = 0; i < instance_number(o_eff_plataction_target); ++i) {
	var ang = 85
	var dist = 9999
	var inst = instance_find(o_eff_plataction_target, i);
	if inst != selection_inst
	and onscreen(inst, -25, undefined, true)
	and point_in_triangle(inst.x, inst.y,
		selection_x,
		selection_y,
		selection_x + lengthdir_x(dist, pressdir - ang),
		selection_y + lengthdir_y(dist, pressdir - ang),
		selection_x + lengthdir_x(dist, pressdir + ang),
		selection_y + lengthdir_y(dist, pressdir + ang)
	)
        array_push(act_targets_array, inst);
}
if id != selection_inst
	array_push(act_targets_array, id);
	
secondbest = array_length(act_targets_array) >= 1 ? instance_nth_nearest(selection_x, selection_y, act_targets_array, 1) : noone

if InputPressedMany([vU, vD, vL, vR]) and best {
	selection_inst = instance_exists(best) ? best : secondbest;
	
	if selection_inst == id
		audio_play(snd_plat_act_move_fail);
	else
		audio_play(snd_plat_act_move);
	
	var fx = selection_x_prev
	var fy = selection_y_prev
	var tx = selection_inst.x
	var ty = selection_inst.y
	var adist = point_distance(fx, fy, tx, ty)
	var adir = point_direction(fx, fy, tx, ty)
	var i = adist/2
	while i < adist {
		var ainst = instance_create(o_eff_generic)
		ainst.x = fx + lengthdir_x(i, adir);
		ainst.y = fy + lengthdir_y(i, adir);
		ainst.life = 99999;
		ainst.sprite_index = spr_soul_full;
		ainst.image_blend = c_red;
		ainst.depth = depth - 10;
		ainst.image_xscale = .5;
		ainst.image_yscale = .5;
		var atrueinst = afterimage(0.1, ainst, false);
		atrueinst.image_alpha = lerp(0.8, 0, 1 - ((i / adist) * 0.5));
		atrueinst.blend = bm_add;
		instance_destroy(ainst);
		i += 12; 
	}
}

if selection_inst != id {
	selection_inst.selected = true
}
