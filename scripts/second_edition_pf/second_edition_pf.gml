global.platforming_perspective = 0
global.allow_use_platswap_statue = true
global.plataction_fade = 0
global.allow_open_plataction = true

// super wip re-re-overhaul for some good terrain support

function player_secondeditionplatforming_init() {
	plf_enabled = floor(global.platforming_perspective)
	plf_state = undefined
	plf_collide = []
	plf_SensorA_dist = 0
	plf_SensorB_dist = 0
	plf_WinningSensor = undefined
	
	plf_vspeed = 0
	plf_gravity = 1.25/2
	plf_airtime = 0

}

function player_secondeditionplatforming_execute() {
	// Keys
	var kU = InputCheck(INPUT_VERB.UP)
	var kD = InputCheck(INPUT_VERB.DOWN)
	var kL = InputCheck(INPUT_VERB.LEFT)
	var kR = InputCheck(INPUT_VERB.RIGHT)
	var cfgFeatherFlipped = false //get config setting
	var verbJump = cfgFeatherFlipped ? INPUT_VERB.SELECT : INPUT_VERB.CANCEL
	var verbAttk = cfgFeatherFlipped ? INPUT_VERB.CANCEL : INPUT_VERB.SELECT
	var kJ = InputCheck(verbJump)
	var kA = InputCheck(verbAttk)
	
	// Collision array
	plf_collide = [];
	for (var i = 0; i < instance_number(o_pf_wall); ++i) {
		var inst = instance_find(o_pf_wall, i);
		if variable_instance_exists(inst, "collide") and inst.collide
            array_push(plf_collide, inst);
	}
	for (var i = 0; i < instance_number(o_ow_plat_ground); ++i) {		  //temporary
		var inst = instance_find(o_ow_plat_ground, i);					  //temporary
		if variable_instance_exists(inst, "collide") and inst.collide	  //temporary
            array_push(plf_collide, inst);								  //temporary
	}																	  //temporary
	
	//Sense
	var bbl = bbox_left
	var bbt = bbox_top
	var bbr = bbox_right
	var bbb = bbox_bottom
	var s
	s = collision_line_point(bbl, bbb, bbl, bbb + 1000, plf_collide, true, true)
	plf_SensorA_dist = abs(bbb-s[2])
	s = collision_line_point(bbr, bbb, bbr, bbb + 1000, plf_collide, true, true)
	plf_SensorB_dist = abs(bbb-s[2])
	if plf_SensorA_dist == plf_SensorB_dist {plf_WinningSensor = "both"}
	else if plf_SensorA_dist < plf_SensorB_dist {plf_WinningSensor = "A"}
	else {plf_WinningSensor = "B"}
	
	//Jumping
	
	
	if (plf_vspeed < 0 or plf_state == "falling") {//and release_jump /*and !pf_hurt*/{
		plf_vspeed *= 0.5;
	}
	
	if array_contains(["jumping", "falling"], plf_state) and plf_airtime > 4 { //and !grounded
		plf_vspeed += plf_gravity;
	}
	
	//Temp
	//player_standard_movement_execute();
	player_standard_movement_locomote(plf_collide, [], 4, , true, false)
	
	
}
