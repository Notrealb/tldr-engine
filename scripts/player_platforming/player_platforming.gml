global.platforming_perspective = 0
global.allow_use_platswap_statue = true
global.plataction_fade = 0
global.allow_open_plataction = true

function player_platforming_movement_init(){
	if !instance_exists(o_pf_platswap_statue) or !instance_exists(o_pf_wall) {global.platforming_perspective=0}
	
	pf_enabled = global.platforming_perspective ? 1 : 0
	pf_caterrecordtime = 0

	pf_collide = []
	
	pf_hmove = 0
	pf_air_accel = 2
	pf_air_decel = 0.5
	pf_ground_accel = 2
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
	
	with get_leader() {player_platforming_movement_init_hook();}
}

function player_platforming_execute(){
	// Statue was hit?
	if ds_exists(pf_slashed_objects, ds_type_list) {
        for (var i = 0; i < ds_list_size(pf_slashed_objects); i ++) {
            with pf_slashed_objects[|i] 
                event_user(1);
        }
	}
	
	// ..
	var _turn_sprite = false;
	
	// Mask
	mask_index = playermask;
	
	// Caterpillar spacing
	pf_caterrecordtime = max(pf_caterrecordtime - 1, 0);
	for (var i = 0; i < party_length(true); ++i) {
		var pinst = party_get_inst(global.party_names[i]);
		pinst.depth = depth + party_get_index(global.party_names[i]);
	}
	
	// Collision array
	pf_collide = [];
	for (var i = 0; i < instance_number(o_pf_wall); ++i) {
		var inst = instance_find(o_pf_wall, i);
		if variable_instance_exists(inst, "collide") and inst.collide and !inst.use_pulpit_collision
            array_push(pf_collide, inst);
	} 
	var ceilded = collision_rectangle(bbox_left, y-pf_ceil_clearance, bbox_right, bbox_bottom-2, pf_collide, true, true)
	for (var i = 0; i < instance_number(o_pf_wall); ++i) {
		var inst = instance_find(o_pf_wall, i);
		if variable_instance_exists(inst, "collide") and inst.collide and !array_contains(pf_collide, inst)
            array_push(pf_collide, inst);
	}
	var grounded = place_meeting(x, bbox_bottom+1, pf_collide);
	
	//if InputPressed(INPUT_VERB.CANCEL)
	//	show_debug_message(string(pf_collide))
	
	// Position saving
	if grounded
	and !place_meeting(x, y, o_pf_nosafespotsaving)
	and place_meeting(x, bbox_bottom+1, pf_collide)
	and place_meeting(x+14, bbox_bottom+4, pf_collide)
	and place_meeting(x-14, bbox_bottom+4, pf_collide)
	and !place_meeting(x, y, pf_collide)
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
	
	// Platforming Horizontal Movement ---------
	//note: turning too slow + sometimes flips without decel; to-redo
	pf_keyLeft = InputCheck(INPUT_VERB.LEFT);
	pf_keyRight = InputCheck(INPUT_VERB.RIGHT);
	var keyPressLeft = InputPressed(INPUT_VERB.LEFT);
	var keyPressRight = InputPressed(INPUT_VERB.RIGHT);
	if pf_keyLeft and pf_keyRight {
		if last_dir_left_right == DIR.RIGHT {
			pf_keyLeft = false;
			keyPressLeft = false;
		}
		else {
			pf_keyRight = false;
			keyPressRight = false;
		}
	}
	
	var _hspeedmax = pf_hmovemax;
	var _hspeedmin = -pf_hmovemax;
	
	var _haccel = pf_air_accel;
	if grounded 
        _haccel = pf_ground_accel;
	
	var _dont_accel = false;
	if (pf_keyLeft and instance_place(x - 4 - abs(pf_hmove), y, pf_collide))
	   or (pf_keyRight and instance_place(x + 4 + abs(pf_hmove), y, pf_collide))
	   or pf_hurt
    {
        _dont_accel = true
    }
	
	var _hdecel = pf_air_decel;
	if grounded
        _haccel = pf_ground_decel;
	if !grounded and abs(pf_hmove) > pf_hmovemax 
        _hdecel = 1;
    
	if pf_hurt {
        if !grounded 
            _hdecel = 0.99;
        else 
            _hdecel = pf_ground_decel;
    }
	
	var force_decel = false;
	if (grounded and pf_attacktime > 0) or pf_hurt 
        force_decel = true;
	
	if !_dont_accel and !(grounded and pf_attacktime > 0){
		if pf_keyLeft {
			if grounded and keyPressLeft
                instance_create(o_eff_generic_animation, x + 16, y, depth, {sprite_index: spr_eff_plat_land_dust, image_xscale: -1});
            
			var last_hspeed = pf_hmove;
			if pf_hmove > 0
				pf_hmove -= _hdecel;
			else
				pf_hmove -= _haccel;
            
			//if run_zone {_hspeedmin = -(dashspeed_modified+4)}
            
			if last_hspeed <=_hspeedmin
                pf_hmove = clamp(pf_hmove*_hdecel, last_hspeed, _hspeedmin);
		}
		if pf_keyRight {
			if grounded and keyPressRight 
                instance_create(o_eff_generic_animation, x - 16, y, depth, {sprite_index: spr_eff_plat_land_dust, image_xscale: 1});
            
			var last_hspeed = pf_hmove;
			if pf_hmove < 0
				pf_hmove += _hdecel;
			else
				pf_hmove += _haccel;
            
			//if run_zone {_hspeedmax = dashspeed_modified-4}
            
			if last_hspeed >=_hspeedmax
                pf_hmove = clamp(pf_hmove*_hdecel, _hspeedmax, last_hspeed);
		}
	}
	
	if ((!pf_keyLeft and !pf_keyRight) or (pf_keyLeft and pf_keyRight) or force_decel) 
        pf_hmove *= _hdecel;
	
	// Platforming Jumping Vertical Movement --------
	var keyIsInvertJumpAndAttack = false
	var verb_jump = keyIsInvertJumpAndAttack ? INPUT_VERB.SELECT : INPUT_VERB.CANCEL
	var verb_attack = keyIsInvertJumpAndAttack ? INPUT_VERB.CANCEL : INPUT_VERB.SELECT
	var keyJump = InputCheck(verb_jump) //or place_meeting(x, y, pf_collide)
	var keyJumpPressed = InputPressed(verb_jump)
	var keyAttack = InputCheck(verb_attack)
	var keyAttackPressed = InputPressed(verb_attack)
	
	if grounded
		pf_airborn_jumps = 0;
	if pf__allow_airborn_jumps and keyJumpPressed and y > pf__airborn_jump_ylimit {
		grounded = true;
		pf_airborn_jumps ++;
	}
	
	if pf_final_ychange > 0 and (pf_jump_key_held_time < 5 or pf__allow_bhopping) and keyJump and collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom+15, pf_collide, true, true) {
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
	pf_final_xchange = pf_hmove
	pf_final_ychange = pf_vspeed
	move_and_collide_simpler(pf_final_xchange, pf_final_ychange, pf_collide)
	
	// Ground fix
	var inst = instance_place(x, y + 1, pf_collide);
	if instance_exists(inst) and instance_position(inst.bbox_left+1, inst.bbox_top, inst) and instance_position(inst.bbox_right-1, inst.bbox_top, inst) {
		y = instance_place(x, y + 1, pf_collide).bbox_top;
	}
	
	// ...
	if !pf_keyLeft and !pf_keyRight and pf_hmove != 0 
        pf_hmove = 0
	
	// Direction
	if pf_hmove == 0 {
		if InputCheck(INPUT_VERB.UP) 
            dir = DIR.UP;
		if InputCheck(INPUT_VERB.DOWN) 
            dir = DIR.DOWN;
	}
	if pf_hmove < 0 {
        pf_dir = DIR.LEFT; 
        dir = pf_dir;
    }
	if pf_hmove > 0 {
        pf_dir = DIR.RIGHT; 
        dir = pf_dir;
    }
    
    if pf_land > 0
        pf_land --;
   // if pf_land_visual > 0
   //     pf_land_visual --;
	
	// Set moving
	if pf_hmove != 0 or pf_final_ychange != 0 or !grounded {
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
				
                var inst_linger = instance_create(o_eff_slash_linger, x, y, DEPTH_PLATFORMER.SLASH);
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