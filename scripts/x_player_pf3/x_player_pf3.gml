function x_player_pf3_define(){
	if !instance_exists(o_pf_platswap_statue) or !instance_exists(o_pf_wall) {global.platforming_perspective=0}
	
	pf_enabled = global.platforming_perspective ? 1 : 0
	pf_caterrecordtime = 0
	
	pf_dummyvar = true
	pf_savedsafeposition = undefined
	
	
	plf_SensorA_dist = 0
	plf_SensorB_dist = 0
	plf_WinningSensor = undefined
	
	player_array_collisions = []
	pf_ceil_clearance = 38;
	
	//pf_jumpstage = undefined
	//plf_vspeed = 0
	//plf_gravity = 1.25/2
	//pf_airtime = 0
	
	pf_hmove = 0
	
	pf__gravity = 1.25/2;
	pf__canjump = true;
	pf__allow_airborn_jumps = false;
	pf__allow_bhopping = false;
	pf__airborn_jump_max = 99;
	pf__airborn_jump_ylimit = 100;
	pf__jumpheight = 7;
	pf__airmintime = 4;
	pf__coyotetimemax = 4;
	pf__squattimemax = 2;
	pf_currentgravity = pf__gravity;
	pf_vspeed = 0;
	pf_jump_key_held_time = 0;
	pf_jumpstage = "grounded";
	pf_airtime = 0;
	pf_coyotetime = 0;
	pf_squattime = 0;
	pf_jumpbuffer = 0;
	pf_airborn_jumps = 0;
	pf_grounded_time = -1;
	pf_ceil_clearance = 38;
	pf_auto_jump_next_land = false;
	
	pf_final_xchange = 0
	pf_final_ychange = 0
	
	pf_grounded = false
	pf_dir = DIR.RIGHT
	pf_xscale_prev = image_xscale;
	pf_turn_timer = 0;
    pf_land = 0;
    pf_land_visual = 0;
	
	pf__attackaddtime = 0.6
	pf__attack_airslash_buffer_max = 15;
	pf_attacking = false;
	pf_attacktime = 0;
	pf_attacktype = 1;
	pf_attacktypeprev = 0;
	pf_attackkeyheldtime = 0;
	pf_attackanimtime = 0;
	pf_attack_key_hold_buffer = 0;
	pf_attack_airslash_buffer = 0;
	
	pf_slashed_objects = -1;
    pf_slashable_objects = [o_pf_slashable];
	
	pf_impact_sfx = snd_punchmed;
	
	pf_hurt = false; //u
	pf_hitstop = 0; //u
	
	
}

function x_player_pf3_exec(){
	mask_index = playermask
	
	// caterpillar spacing
	for (var i = 0; i < party_length(true); ++i) {
		var pinst = party_get_inst(global.party_names[i]);
		var targpos = get_leader().spacing * party_get_index(global.party_names[i]);
		pinst.pos = increment_towards(pinst.pos, targpos, 2);
	}
	
	// re-appraise the collision array
	player_array_collisions = [];
	for (var i = 0; i < instance_number(o_pf_wall); ++i) {
		var inst = instance_find(o_pf_wall, i);
		if variable_instance_exists(inst, "collide") and inst.collide and !inst.use_pulpit_collision
            array_push(player_array_collisions, inst);
	} 
	var ceilded = collision_rectangle(bbox_left, y-pf_ceil_clearance, bbox_right, bbox_bottom-2, player_array_collisions, true, true)
	for (var i = 0; i < instance_number(o_pf_wall); ++i) {
		var inst = instance_find(o_pf_wall, i);
		if variable_instance_exists(inst, "collide") and inst.collide and !array_contains(player_array_collisions, inst)
            array_push(player_array_collisions, inst);
	}
	var grounded = place_meeting(x, bbox_bottom+1, player_array_collisions);
	
	// Position saving
	if grounded
	and !place_meeting(x, y, o_pf_zone_nosafespotsaving)
	and place_meeting(x, bbox_bottom+1, player_array_collisions)
	and place_meeting(x+14, bbox_bottom+4, player_array_collisions)
	and place_meeting(x-14, bbox_bottom+4, player_array_collisions)
	and !place_meeting(x, y, player_array_collisions)
	{
		pf_savedsafeposition = [x, y]
	}
	
	// Pitfall rescue
	if y > room_height + 100
	and !collision_rectangle(bbox_left-10, y-pf_ceil_clearance, bbox_right+10, bbox_bottom+100, o_trigger_warp, true, true)
	{
		cutscene_create();
		cutscene_player_canmove(false);
		cutscene_sleep(10);
		cutscene_set_variable(o_camera, "target", noone);
		cutscene_set_variable(get_leader(), "pf_pitfallrescuing", true)
		
		if party_length(true) > 1 { for (var i = 1; i < party_length(true); i ++) {
			var inst = party_get_inst(global.party_names[i])
			cutscene_animate(inst.image_alpha, 0, 10, "linear", inst, "image_alpha")
		}}
		
		cutscene_camera_pan(pf_savedsafeposition[0], pf_savedsafeposition[1], 16, true, "cubic_in_out");
		
		cutscene_func(function(){
			get_leader().x = pf_savedsafeposition[0];
			get_leader().y = o_camera.y + o_camera.height + 60;
		})
		cutscene_party_follow(true);
		cutscene_party_interpolate();
		cutscene_sleep(1);
		
		if party_length(true) > 1 { for (var i = 1; i < party_length(true); i ++) {
			var inst = party_get_inst(global.party_names[i])
			cutscene_animate(-2, 1, 20, "linear", inst, "image_alpha")
		}}
		cutscene_func(function(){
			get_leader().vspeed = -10
		})
		cutscene_audio_play(snd_wing_pitfall)
		cutscene_wait_until(function() {
			return (get_leader().y <= get_leader().pf_savedsafeposition[1])
		});
		
		cutscene_animate(-10, 10, 20, "linear", get_leader(), "vspeed")
		cutscene_wait_until(function() {
			var l = get_leader()
			return (((l.y >= l.pf_savedsafeposition[1] - abs(l.vspeed)) or (l.y >= l.pf_savedsafeposition[1])) and l.vspeed > 0)
		});
		
		cutscene_func(function(){
			get_leader().vspeed = 0
			get_leader().y = get_leader().pf_savedsafeposition[1]
		})
		cutscene_set_variable(o_camera, "target", get_leader())
		cutscene_set_variable(get_leader(), "pf_pitfallrescuing", false)
		cutscene_player_canmove(true);
		cutscene_play();
		return
	}
	


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
	
	//Sense
	var bbl = bbox_left
	var bbt = bbox_top
	var bbr = bbox_right
	var bbb = bbox_bottom
	var s
	s = collision_line_point(bbl, bbb, bbl, bbb + 1000, player_array_collisions, true, true)
	plf_SensorA_dist = abs(bbb-s[2])
	s = collision_line_point(bbr, bbb, bbr, bbb + 1000, player_array_collisions, true, true)
	plf_SensorB_dist = abs(bbb-s[2])
	if plf_SensorA_dist == plf_SensorB_dist {plf_WinningSensor = "both"}
	else if plf_SensorA_dist < plf_SensorB_dist {plf_WinningSensor = "A"}
	else {plf_WinningSensor = "B"}
	
	//Jumping
	//if (plf_vspeed < 0 or pf_jumpstage == "falling") {//and release_jump /*and !pf_hurt*/{
	//	plf_vspeed *= 0.5;
	//}
	//
	//if array_contains(["jumping", "falling"], pf_jumpstage) and pf_airtime > 4 { //and !grounded
	//	plf_vspeed += plf_gravity;
	//}
	// Platforming Jumping Vertical Movement --------
	var keyIsInvertJumpAndAttack = false
	var verb_jump = keyIsInvertJumpAndAttack ? INPUT_VERB.SELECT : INPUT_VERB.CANCEL
	var verb_attack = keyIsInvertJumpAndAttack ? INPUT_VERB.CANCEL : INPUT_VERB.SELECT
	var keyJump = InputCheck(verb_jump) //or place_meeting(x, y, player_array_collisions)
	var keyJumpPressed = InputPressed(verb_jump)
	var keyAttack = InputCheck(verb_attack)
	var keyAttackPressed = InputPressed(verb_attack)
	
	if grounded
		pf_airborn_jumps = 0;
	if pf__allow_airborn_jumps and keyJumpPressed and y > pf__airborn_jump_ylimit {
		grounded = true;
		pf_airborn_jumps ++;
	}
	
	if pf_final_ychange > 0 and (pf_jump_key_held_time < 5 or pf__allow_bhopping) and keyJump and collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom+15, player_array_collisions, true, true) {
		pf_auto_jump_next_land = true;
		//audio_play(snd_break1)
	}
	if pf_jumpstage == "grounded" and pf_auto_jump_next_land {
		pf_jump_key_held_time = 0;
		keyJumpPressed = true;
		//audio_play(snd_break2)
		pf_auto_jump_next_land = false;
	}
	
	if !pf__canjump {
        keyJump = 0; 
        keyJumpPressed = 0;
    }
	
	if keyJumpPressed
        pf_jumpbuffer = 4;
    else 
        pf_jumpbuffer = max(pf_jumpbuffer - 1, 0);
	
	if grounded {
		if pf_airtime > pf__airmintime and o_fader.image_alpha == 0 && pf_jumpstage == "falling" {
            instance_create(o_eff_generic_animation, x - 16, y, depth, {sprite_index: spr_eff_plat_land_dust, image_xscale: 1});
            instance_create(o_eff_generic_animation, x + 16, y, depth, {sprite_index: spr_eff_plat_land_dust, image_xscale: -1});
            if pf_hmove == 0 and pf_attacktime == 0 and pf_airborn_jumps == 0 {
                audio_play(snd_noise, , , 1.2);
	            pf_land = 8;
	            //pf_land_visual = 6;
			}
		}
		pf_jumpstage = "grounded";
		pf_vspeed = 0;
		pf_airtime = 0;
		pf_coyotetime = pf__coyotetimemax;
	}
	else {
		pf_airtime ++;
		if pf_jumpstage == "grounded"
			pf_jumpstage = "falling";
	}
	
	var release_jump = false;
	if ceilded or (!keyJump and pf_airtime >= pf__coyotetimemax) {
        release_jump = true; 
        pf_airtime = max(pf_airtime, pf__coyotetimemax);
    }
	
	if !pf_jumpbuffer and pf_squattime <= 0 and (!grounded and pf_coyotetime > 0) 
        pf_coyotetime --;
		
	if keyJump {
		pf_jump_key_held_time ++;
		
		if pf_attacktime > 0
			pf_jump_key_held_time = 0;
        
		if pf_jump_key_held_time < 4 and (grounded or (pf_coyotetime > 0 and pf_vspeed > -1)) and !pf_attacktime > 0 and !pf_hurt {
		    var inc = 1;
		    pf_squattime = max(pf_squattime + inc, 1);
		    pf_jumpbuffer = 0;
        
			if pf_squattime > pf__squattimemax {
				pf_squattime = 0;
				pf_coyotetime = 0;
            
				if !ceilded {
	                y -= 1; 
	                pf_vspeed = -pf__jumpheight; 
	                pf_jumpstage = "jumping";
					pf_auto_jump_next_land = false;
	                audio_play(snd_ui_cancel_small, , , 1.5);
	            }
			}
		}
		else {
	        pf_squattime = 0;
		}
	}
	else {
		pf_jump_key_held_time = 0;
		if (pf_jumpstage == "jumping" and pf_airtime > pf__airmintime) {
			release_jump = true;
			pf_jumpstage = "falling";
		}
	}
    
	if (pf_vspeed < 0 or pf_hitstop > 0) and release_jump /*and !pf_hurt*/{
		pf_vspeed *= 0.5;
	}
	
	if array_contains(["jumping", "falling"], pf_jumpstage) and !grounded and pf_airtime > pf__airmintime {
		pf_vspeed += pf_currentgravity;
	}
	
	// Platforming Finish Movement -----
	//pf_final_xchange = pf_hmove
	pf_final_ychange = pf_vspeed
	
	
	// locomote
	player_locomote_and_collide_except(noclip ? noone : player_array_collisions, player_array_exceptions, 4,
		undefined, //speedmult
		false, //actordir
		undefined, //yaw
		undefined, //override x
		pf_final_ychange, //override y
		undefined,
		undefined,
		{U : 0, D : 4, L : 0, R : 0},
		undefined,
		undefined,
		true
	);
	
	// set moving
	//moving = am_locomoting;
	
	// Set moving
	pf_final_xchange = locomotionX
	pf_final_ychange = locomotionY
	if /*pf_hmove != 0 or*/ pf_final_ychange != 0 or !grounded {
        moving = true;
    }	
	
	// 

    pf_grounded = grounded;
    x_player_pf3_actor_animate(pf_grounded, pf_final_xchange, pf_final_ychange, pf_dir);
}

function x_player_pf3_actor_animate(_grounded, _dx, _dy, _dir) {
    var turn_anim_len = 6;
    
    image_xscale = (_dir == DIR.RIGHT ? 1 : -1);
    image_speed = 1;
    
	if !variable_instance_exists(self, "pf_xscale_prev")
		pf_xscale_prev = image_xscale;
	if !variable_instance_exists(self, "pf_airtime")
		pf_airtime = 0;
	if !variable_instance_exists(self, "pf_jumpstage")
		pf_jumpstage = undefined;
	if !variable_instance_exists(self, "pf_land_visual")
		pf_land_visual = 0;
	if !variable_instance_exists(self, "pf_turn_timer")
		pf_turn_timer = 0;
	
    if pf_xscale_prev != image_xscale && pf_turn_timer == 0
        pf_turn_timer = turn_anim_len;
    
	if pf_airtime <= 1 and pf_jumpstage == "jumping" {
        sprite_index = s_plat_land;
        image_index = 0;
	}
    else if !_grounded {
        if _dy < 0
            sprite_index = s_plat_jump_up;
        else if _dy >= 0 
            sprite_index = s_plat_jump_down;
    }
    else if pf_land > 0 || pf_land_visual > 0 {
        sprite_index = s_plat_land;
        image_index = (image_number - 1) * pf_land/8;
    }
    else if _dx != 0 {
        if pf_turn_timer > 0 {
            sprite_index = s_plat_turn;
            image_index = (1 - pf_turn_timer/turn_anim_len) * (sprite_get_number(s_plat_turn) - 1);
            image_speed = 0;
        }
        else
            sprite_index = s_plat_run;
    }
    else if (sprite_index == s_plat_run || sprite_index == s_plat_turn) {
        sprite_index = s_plat_run_stop;
        image_index = 0;
        queued_sprite = s_plat_idle;
    }
    else if sprite_index != s_plat_run_stop
        sprite_index = s_plat_idle;
    
    pf_xscale_prev = image_xscale;
    if pf_turn_timer > 0
        pf_turn_timer --;
}