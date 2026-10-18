// make the dodge effects fade in and fade out
if !dodge_override {
	if dodge_mode
		dodge_alpha = lerp(dodge_alpha, 1, global.platforming_perspective ? 0.16 : .2)
	else 
		dodge_alpha = lerp(dodge_alpha, 0, global.platforming_perspective ? 0.1 : .15)
    
	dodge_alpha = clamp(dodge_alpha, 0, 1)
}

// change values to use based on platforming perspective
dodge_base_alpha = lerp(dodge_base_ow_alpha, dodge_base_pf_alpha, global.platforming_perspective)
dodge_darken = lerp(dodge_ow_darken, dodge_pf_darken, global.platforming_perspective)

// check collision with dodge triggers
var l = get_leader()
with get_leader() {
	var tda = [];
	for (var i = 0; i < instance_number(o_trigger_dodge); ++i) {
		var inst = instance_find(o_trigger_dodge, i);
		var check_can = inst.can_trigger && ((inst.can_while_platforming and global.platforming_perspective) or (inst.can_while_not_platforming and global.platforming_perspective == 0))
		if check_can
            array_push(tda, inst);
	}
	var tdea = [];
	for (var i = 0; i < instance_number(o_trigger_dodge_exception); ++i) {
		var inst = instance_find(o_trigger_dodge_exception, i);
		var check_can = inst.can_trigger && ((inst.can_while_platforming and global.platforming_perspective) or (inst.can_while_not_platforming and global.platforming_perspective == 0))
		if check_can
            array_push(tdea, inst);
	}
	if collision_point_except(x, y, tda, tdea) {
		o_dodge_controller.dodge_mode = true
	}else{
		o_dodge_controller.dodge_mode = false
	}
}