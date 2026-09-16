global.platforming_perspective = 0
global.allow_use_platswap_statue = true
global.plataction_fade = 0
global.allow_open_plataction = true

function player_platforming_movement_init(){
	pf_enabled = global.platforming_perspective ? 1 : 0
	pf_caterrecordtime = 0

	player_array_collisions = []
	
	pf_hmove = 0
	pf_air_accel = 2/2
	pf_air_decel = 0.5
	pf_ground_accel = 2/2
	pf_ground_decel = 0.65
	pf_hmovemax = 4.5
	pf_keyLeft = 0
	pf_keyRight = 0

	pf_dir = DIR.RIGHT
    
    pf_xscale_prev = image_xscale;
    pf_turn_timer = 0;
	
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
	pf_final_xchange = 0;
	pf_final_ychange = 0;
    pf_land = 0;
    pf_land_visual = 0;
    pf_grounded = true;
	pf_airborn_jumps = 0;
	pf_grounded_time = -1;
	pf_ceil_clearance = 38;
	pf_auto_jump_next_land = false;
	
	pf_savedsafeposition = [x, y];
	
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
	
	pf_pitfallrescuing = false
	
	
	plf_SensorA_dist = 0
	plf_SensorB_dist = 0
	plf_WinningSensor = undefined
	
	pf_AllowJumping = true
	pf_AllowWalking = true
	pf_DoPitfallRescue = true
	
	spacing_plat = 6
}

function player_platforming_execute(){
	// Run hit event in slashable objects if any were hit last frame.
	if ds_exists(pf_slashed_objects, ds_type_list) {
        for (var i = 0; i < ds_list_size(pf_slashed_objects); i ++) {
            with pf_slashed_objects[|i] 
                event_user(1);
        }
		ds_list_destroy(pf_slashed_objects);
	}
	pf_slashed_objects = -1;
	
	// Mask
	mask_index = playermask;
	
	// Party caterpillar spacing and depth
	spacing = spacing_plat
	pf_caterrecordtime = max(pf_caterrecordtime - 1, 0);
	for (var i = 0; i < party_length(true); ++i) {
		var pinst = party_get_inst(global.party_names[i]);
		var targpos = get_leader().spacing_plat * party_get_index(global.party_names[i]);
		pinst.pos = increment_towards(pinst.pos, targpos, 2);
		pinst.depth = depth + party_get_index(global.party_names[i]);
	}
	
	// Distance sensing
	var bbl = bbox_left + 4
	var bbt = bbox_top
	var bbr = bbox_right - 4
	var bbb = bbox_bottom
	var s
	s = collision_line_point(bbl, bbb, bbl, bbb + 1000, player_array_collisions, true, true)
	plf_SensorA_dist = abs(bbb-s[2])
	s = collision_line_point(bbr, bbb, bbr, bbb + 1000, player_array_collisions, true, true)
	plf_SensorB_dist = abs(bbb-s[2])
	if plf_SensorA_dist == plf_SensorB_dist {plf_WinningSensor = "both"}
	else if plf_SensorA_dist < plf_SensorB_dist {plf_WinningSensor = "A"}
	else {plf_WinningSensor = "B"}
	
	// Collision array
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
	var grounded = (!place_meeting(x, y, o_pf_zone_nogrounding) and (
		place_meeting(x, bbox_bottom+2, player_array_collisions)
		//or point_distance(0, plf_SensorA_dist, 0, plf_SensorB_dist) > 2 and place_meeting(x, bbox_bottom+3, player_array_collisions)
	))
	
	// Pitfall rescue
	if pf_DoPitfallRescue {
		if grounded
		and !place_meeting(x, y, o_pf_zone_nosafespotsaving)
		and place_meeting(x, bbox_bottom+1, player_array_collisions)
		and place_meeting(x+14, bbox_bottom+4, player_array_collisions)
		and place_meeting(x-14, bbox_bottom+4, player_array_collisions)
		and !place_meeting(x, y, player_array_collisions)
		{
			pf_savedsafeposition = [x, y]
		}
		
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
	}
	
	// Horizontal walking
	var Verbs = {U : INPUT_VERB.UP, D : INPUT_VERB.DOWN, L : INPUT_VERB.LEFT, R : INPUT_VERB.RIGHT}
	var inpcL = InputCheck(Verbs.L)
	var inpcR = InputCheck(Verbs.R)
	if pf_AllowWalking {
		var hacl = grounded ? pf_ground_accel : pf_air_accel
	
		var dacc = false;
		if (grounded and pf_attacking)
		//or (hurt || jumping == 3 || dashing_end)
		or (inpcL and instance_place(bbox_left - abs(pf_final_xchange), y, player_array_collisions))
		or (inpcR and instance_place(bbox_right + abs(pf_final_xchange), y, player_array_collisions))
			dacc = true;
	
		var hdcl = grounded ? pf_ground_decel : pf_air_decel
		if !grounded and (abs(pf_final_xchange) > (pf_hmovemax + (2.1/2)))
			hdcl = 0.5;
	
		var fdcl = pf_hurt or (grounded and pf_attacking)
	
		if !dacc {
			if inpcL {
				if grounded and InputPressed(Verbs.L)
					instance_create(o_eff_generic_animation, x + 16, y, depth, {sprite_index: spr_eff_plat_land_dust, image_xscale: -1});
				pf_hmove -= hacl;
				if pf_final_xchange <= -pf_hmovemax
					pf_hmove = clamp(pf_hmove * hdcl, pf_final_xchange, -pf_hmovemax);
			}
			else if inpcR {
				if grounded and InputPressed(Verbs.R)
					instance_create(o_eff_generic_animation, x - 16, y, depth, {sprite_index: spr_eff_plat_land_dust, image_xscale: 1});
				pf_hmove += hacl;
				if pf_final_xchange >= pf_hmovemax
					pf_hmove = clamp(pf_hmove * hdcl, pf_hmovemax, pf_final_xchange);
			}
		}
	
		if fdcl or (!inpcL and !inpcR) or (inpcL and inpcR)
			pf_hmove *= hdcl;
	
		//if point_distance(0, plf_SensorA_dist, 0, plf_SensorB_dist) > 2
		//	pf_hmove = (pf_hmove > 2 or pf_hmove < -2) ? floor(pf_hmove) : ceil(pf_hmove); //?????
		
		//if dacc and (pf_final_xchange > -1 and pf_final_xchange < 1)
		//	pf_hmove = 0;
		
		/*if (plf_SensorA_dist < 4 or plf_SensorB_dist < 4) and min(plf_SensorA_dist, plf_SensorB_dist) < 4 {
			if point_direction(0, plf_SensorA_dist, 0, plf_SensorB_dist) > 40
				pf_hmove = lerp(pf_hmove, pf_hmovemax, 0.5)
			if point_direction(0, plf_SensorA_dist, 0, plf_SensorB_dist) < -40
				pf_hmove = lerp(pf_hmove, -pf_hmovemax, 0.5)
		}*/
	}
	else
		pf_hmove = 0;
	
	// Vertical jumping
	var keyIsInvertJumpAndAttack = false
	var verb_jump = keyIsInvertJumpAndAttack ? INPUT_VERB.SELECT : INPUT_VERB.CANCEL
	var verb_attack = keyIsInvertJumpAndAttack ? INPUT_VERB.CANCEL : INPUT_VERB.SELECT
	var keyJump = InputCheck(verb_jump)
	var keyJumpPressed = InputPressed(verb_jump)
	var keyAttack = InputCheck(verb_attack)
	var keyAttackPressed = InputPressed(verb_attack)
	if pf_AllowJumping {
		if grounded
			pf_airborn_jumps = 0;
		
		if pf__allow_airborn_jumps and keyJumpPressed and y > pf__airborn_jump_ylimit {
			grounded = true;
			pf_airborn_jumps ++;
		}
	
		if pf_final_ychange > 0 and (pf_jump_key_held_time < 5 or pf__allow_bhopping) and keyJump and collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom+15, player_array_collisions, true, true) {
			pf_auto_jump_next_land = true;
		}
		
		if pf_jumpstage == "grounded" and pf_auto_jump_next_land {
			pf_jump_key_held_time = 0;
			keyJumpPressed = true;
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
		if ceilded
		or (!keyJump and pf_airtime >= pf__coyotetimemax)
		{
	        release_jump = true; 
	        pf_airtime = max(pf_airtime, pf__coyotetimemax);
	    }
	
		if !pf_jumpbuffer
		and pf_squattime <= 0
		and (!grounded and pf_coyotetime > 0) 
	        pf_coyotetime --;
		
		if keyJump
		{
			pf_jump_key_held_time ++;
		
			if pf_attacktime > 0
				pf_jump_key_held_time = 0;
        
			if pf_jump_key_held_time < 4
			and (grounded or (pf_coyotetime > 0 and pf_vspeed > -1))
			and !pf_attacktime > 0
			and !pf_hurt
			{
			    pf_squattime = max(pf_squattime + 1, 1);
			    pf_jumpbuffer = 0;
				if pf_squattime > pf__squattimemax
				{
					pf_squattime = 0;
					pf_coyotetime = 0;
					if !ceilded
					{
		                y -= 1; 
		                pf_vspeed = -pf__jumpheight; 
		                pf_jumpstage = "jumping";
						pf_auto_jump_next_land = false;
		                audio_play(snd_ui_cancel_small, , , 1.5);
		            }
				}
			}
			else
				pf_squattime = 0;
		}
		else
		{
			pf_jump_key_held_time = 0;
			if (pf_jumpstage == "jumping" and pf_airtime > pf__airmintime) {
				release_jump = true;
				pf_jumpstage = "falling";
			}
		}
    
		if (pf_vspeed < 0 or pf_hitstop > 0)
		and release_jump
		/*and !pf_hurt*/
			pf_vspeed *= 0.5;
	
		if array_contains(["jumping", "falling"], pf_jumpstage)
		and !grounded
		and pf_airtime > pf__airmintime {
			pf_vspeed += pf_currentgravity;
		}
	
		pf_vspeed = clamp(pf_vspeed, -pf__jumpheight, 10);
	}
	else
		pf_vspeed = 0
	
	// Locomote
	pf_final_xchange = pf_hmove
	pf_final_ychange = pf_vspeed
	if pf_final_ychange > min(plf_SensorA_dist, plf_SensorB_dist)
		pf_final_ychange = min(plf_SensorA_dist, plf_SensorB_dist);
	var sicheck = instance_place(x, y, o_pf_zone_setstickiterations)
	player_locomote_and_collide_except(noclip ? noone : player_array_collisions, player_array_exceptions, 4,
		undefined, //speedmult
		false, //actordir
		270 + 0, //yaw
		pf_final_xchange, //override x
		pf_final_ychange, //override y
		undefined, //add x
		undefined, //add y
		{U : 0, D : sicheck ? sicheck.down_iterations : 0, L : 0, R : 0},
		true, //StickUseKeysToo
		false, //DoCircularize
		false, //slowintowalls
		undefined, //positionrounding
		false, //SuppressHorizontalInput
		true, //SuppressVerticalInput
		true, //RestrictXBasedOnPreviousY - enabled to fix insta-sticking when jumping to higher ground
		false //RestrictYBasedOnPreviousX
	);
	
	// Direction
	if pf_final_xchange == 0 {
		if InputCheck(INPUT_VERB.UP) 
            dir = DIR.UP;
		if InputCheck(INPUT_VERB.DOWN) 
            dir = DIR.DOWN;
	}
	if pf_final_xchange < 0 {
        pf_dir = DIR.LEFT; 
        dir = pf_dir;
    }
	if pf_final_xchange > 0 {
        pf_dir = DIR.RIGHT; 
        dir = pf_dir;
    }
    
    if pf_land > 0
        pf_land --;
	
	// Set moving
	moving = false;
	var _dv = 1.902
	if /*inpcL or inpcR or*/ !(pf_final_xchange < _dv and pf_final_xchange > -_dv) or pf_final_ychange != 0 or !grounded {
        moving = true;
    }
	
    pf_grounded = grounded;
    actor_platforming_animate(pf_grounded, pf_final_xchange, pf_final_ychange, pf_dir);
	
	// Combat
	if y != yprevious
		pf_grounded = false;
	
	if pf_attack_airslash_buffer > 0
		keyAttackPressed = false;
	
	if pf_grounded == false {
		keyAttack = keyAttackPressed;
		if keyAttackPressed
			pf_attack_airslash_buffer = pf__attack_airslash_buffer_max;
	}
	
	if keyAttack
		pf_attack_key_hold_buffer = 4;
	else
		pf_attack_key_hold_buffer = max(pf_attack_key_hold_buffer - 1, 0);
	
	if pf_attack_key_hold_buffer
		pf_attackkeyheldtime++;
	else
		pf_attackkeyheldtime = 0;
	
	if (pf_attackkeyheldtime > 0 and pf_attackkeyheldtime < 4) or pf_attacktime > 0
		pf_attacktime += pf__attackaddtime;
	
	if pf_attacktime > 0 or pf_attacking {
		var store_landingslash = false
		if grounded and (pf_attacking and pf_attacktype == 2) {
			pf_attacktime = 0;
			pf_attacking = false;
			InputVerbConsume(keyIsInvertJumpAndAttack ? INPUT_VERB.CANCEL : INPUT_VERB.SELECT);
			pf_jump_key_held_time = 0;
			pf_attack_key_hold_buffer = 0;
		}
		else if grounded {
			actor_platforming_combat_npointex(s_plat_slash_ground, s_plat_slash_ground_hbx, s_plat_slash_ground_fg, s_plat_slash_npoints_ground, pf_attack_key_hold_buffer, keyAttackPressed, keyJumpPressed);
			pf_attacktype = 1;
		}
		else {
			actor_platforming_combat_npointex(s_plat_slash_air, s_plat_slash_air_hbx, s_plat_slash_air_fg, s_plat_slash_npoints_air, pf_attack_key_hold_buffer, keyAttackPressed, keyJumpPressed);
			pf_attacktype = 2;
		}
		
		if pf_attacktime == 0
			pf_attacking = false;
	}
	
	//if pf_attacktype != pf_attacktypeprev
	//	InputVerbConsume(keyIsInvertJumpAndAttack ? INPUT_VERB.CANCEL : INPUT_VERB.SELECT);
	
	pf_attacktypeprev = pf_attacktype;
	pf_attack_airslash_buffer = max(pf_attack_airslash_buffer-1, 0)
	if pf_grounded
		pf_grounded_time ++;
	else
		pf_grounded_time = -1;
		
	// -------- plataction opening ---------
	if global.allow_open_plataction and InputPressed(INPUT_VERB.SPECIAL) {
		audio_play(snd_spearrise)
		instance_create(o_ui_plataction)
	}
}

function actor_platforming_animate(_grounded, _dx, _dy, _dir) {
	if s_override exit
	
    var turn_anim_len = 6;
    
    image_xscale = (_dir == DIR.RIGHT ? 1 : -1);
    image_speed = 1;
    
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
    else if !(_dx < 1 and _dx > -1) {
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

function actor_platforming_combat_npointex(_sprite, _hbxsprite, _fgsprite, _npoints_array, _keyAttackBuffer, _keyAttackPressed, _keyJumpPressed) { // 
	var tempsprite = sprite_index;
	var tempimage = image_index;
	sprite_index = _sprite;
    
	pf_attacking = true;
    
	for (var i = 0; i < array_length(_npoints_array); i ++) {
		if _npoints_array[i][0] == snd_ultraswing and pf_attacktime < _npoints_array[i][1] and ((!pf_grounded) or (pf_attacktype == 1 and pf_grounded_time < 4 and _keyAttackPressed)) {
			pf_attacktime = _npoints_array[i][1]
			pf_attackkeyheldtime = 0;
		}
		image_index = clamp(pf_attacktime, 0, sprite_get_number(sprite_index) - 1);
        
		for (var j = 1; j < array_length(_npoints_array[i]); j ++) {
			if (array_contains([floor(image_index)], _npoints_array[i][j])
				and !_keyAttackBuffer
				or (pf_attacktype != pf_attacktypeprev)
			)
			or (pf_attacktime >= sprite_get_number(sprite_index) - 1) 
            {
				pf_attacktime = 0;
				sprite_index = tempsprite;
				image_index = tempimage;
			}
			else if floor(image_index) == _npoints_array[i][j] and _keyAttackBuffer and image_index < floor(image_index) + pf__attackaddtime {
				if _npoints_array[i][0] != "nul"
					audio_play(_npoints_array[i][0], , , array_contains([snd_heavyswing, snd_ultraswing], _npoints_array[i][0]) ? 1.1 : 1);
				
				var potential_slashables = ds_list_create();
                collision_rectangle_list(x - (pf_dir == DIR.LEFT ? 30 : 10), y+10, x + (pf_dir == DIR.RIGHT ? 30 : 10), y-50, pf_slashable_objects, true, true, potential_slashables, false);
                
				if ds_list_size(potential_slashables) > 0 {
					pf_slashed_objects = potential_slashables;
					audio_stop_sound(pf_impact_sfx);
					audio_play(pf_impact_sfx);
				}
				
				var inst_linger = instance_create(o_eff_slash_linger, -999, -999, DEPTH_PLATFORMER.SLASH);
                inst_linger.target = id;
                inst_linger.sprite_index = _fgsprite;
                inst_linger.image_xscale = image_xscale;
                inst_linger.image_yscale = image_yscale;
                inst_linger.image_index = image_index;
                inst_linger.image_speed = 0;
			}
		}
	}
}