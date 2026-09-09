function player_standard_movement_execute(){
	mask_index = playermask

	// caterpillar spacing
	for (var i = 0; i < party_length(true); ++i) {
		var pinst = party_get_inst(global.party_names[i]);
		var targpos = get_leader().spacing * party_get_index(global.party_names[i]);
		pinst.pos = increment_towards(pinst.pos, targpos, 2);
	}
	
    // re-appraise the collision array
    player_array_collisions = [];
	for (var i = 0; i < instance_number(o_block); ++i) {
		var inst = instance_find(o_block, i);
		if variable_instance_exists(inst, "collide") and inst.collide
            array_push(player_array_collisions, inst);
	}
	
	// set speed for running and not running
	auto_run = global.settings.AUTO_RUN
	if ((!auto_run and InputCheck(INPUT_VERB.CANCEL)) or (auto_run and !InputCheck(INPUT_VERB.CANCEL))) and moving {
		running = true;
		runtimer ++;
		
		spd = basespd
		if global.world == WORLD_TYPE.LIGHT {
			spd = basespd + 1
			if runtimer > 10 
                spd = basespd+2;
			if runtimer > 60 
                spd = basespd+3;
		}
        else{
			spd = basespd + 1
			if runtimer > 10 
                spd = basespd+2;
			if runtimer > 60 
                spd = basespd+2.5;
		}
	}
    else {
		running = false;
		runtimer = 0;
		spd = basespd;
	}
    
	// locomote
	player_locomote_and_collide_except(noclip ? noone : player_array_collisions, player_array_exceptions, spd);
	
	// set moving
	moving = am_locomoting;
	
	// set direction
	if locomote_calculated_direction != undefined
		dir = locomote_calculated_direction;
		
	// make steps and call the `__step` method
	if !sliding && (track_footsteps || is_player) {
		if floor((image_index % image_number)*2) % 2 != 0 {
	        if !made_step {
	            __step(floor(image_index % image_number));
	            made_step = true;
	        }
		}
		else 
	        made_step = false;
	}
}