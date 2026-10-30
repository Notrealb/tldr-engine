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

act_targets_array = []
__act_targets_array_do_node_search(35)
best = array_length(act_targets_array) >= 1 ? instance_nth_nearest(selection_x, selection_y, act_targets_array, 1) : noone
__act_targets_array_do_node_search(85)
secondbest = array_length(act_targets_array) >= 1 ? instance_nth_nearest(selection_x, selection_y, act_targets_array, 1) : noone

var currect_select_is_suddenly_unavailable_so_MOVE_please = (
	selection_inst.object_index == o_plat_action_node
	and (
		!selection_inst.active
		or selection_inst.protected
		or selection_inst.blocked
		or selection_inst.superblocked
		or selection_inst.char_in_cooldown
		or !party_contains(selection_inst.char, true)
	)
)

if (InputPressedMany([vU, vD, vL, vR]) and best)
or currect_select_is_suddenly_unavailable_so_MOVE_please
{
	if currect_select_is_suddenly_unavailable_so_MOVE_please
		selection_inst = id;
	else
		selection_inst = instance_exists(best) ? best : secondbest;
	
	if selection_inst == id
		audio_play(snd_plat_act_move_fail);
	else
		audio_play(snd_plat_act_move);
	
	__txt_desc_typer_clear();
	
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

acts_are_available = false;
even_though_acts_are_available_we_cant_select_because = [];
but_there_are_available_acts_anyway = false;
with o_plat_action_node {
	if onscreen(self, other.onscreenrange, undefined, true)
		other.acts_are_available = true;
	if other.acts_are_available = true {
		if blocked
			array_push(other.even_though_acts_are_available_we_cant_select_because, "blocked")
		if superblocked
			array_push(other.even_though_acts_are_available_we_cant_select_because, "superblocked")
		if protected
			array_push(other.even_though_acts_are_available_we_cant_select_because, "protected")
		if !(blocked or superblocked or protected)
			other.but_there_are_available_acts_anyway_so_this_doesnt_matter = true;
	}
}

if selection_inst.object_index == o_plat_action_node {
	selection_inst.selected = true;
	__txt_desc_typer_make();
} else {
	__txt_desc_typer_clear();
}