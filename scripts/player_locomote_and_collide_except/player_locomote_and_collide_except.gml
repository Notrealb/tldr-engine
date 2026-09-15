//Yaw = point_direction(x, y, mouse_x, mouse_y) + 180 //Demonstration: Mouse-based yaw setting.
//player_locomote_and_collide_except
//player_do_movement_standard
//player_do_interaction_standard

function player_locomote_and_collide_except(_colo, _xcep, StepSpeed, 
	SpeedMultipliers = {X : 1, Y : 1, U : 1, D : 1, L : 1, R : 1}, 
	DoCalculateActorDirection = true, 
	Yaw = 270, 
	OverrideAttemptX = 0, 
	OverrideAttemptY = 0, 
	AddAttemptX = 0, 
	AddAttemptY = 0, 
	StickIterations = {U : 0, D : 0, L : 0, R : 0},
	StickUseKeysToo = false,
	DoCircularize = false,
	SlowIntoWalls = true,
	PositionRounding = 0.5,
	SuppressHorizontalInput = false, 
	SuppressVerticalInput = false,
	Verbs = {U : INPUT_VERB.UP, D : INPUT_VERB.DOWN, L : INPUT_VERB.LEFT, R : INPUT_VERB.RIGHT}, 
	ForcedKeys = []
)
{
	// Get opposing keys
	var KeysOpposingX = (array_contains(ForcedKeys, Verbs.L) ? -1 : -InputCheck(Verbs.L)) + (array_contains(ForcedKeys, Verbs.R) ? 1 : InputCheck(Verbs.R))
	var KeysOpposingY = (array_contains(ForcedKeys, Verbs.U) ? -1 : -InputCheck(Verbs.U)) + (array_contains(ForcedKeys, Verbs.D) ? 1 : InputCheck(Verbs.D))
	
	//
	var attemptX = 0;
	var attemptY = 0;
	StepSpeed = max(StepSpeed, PositionRounding);
	
	// Calculate attemptX and attemptY
	if OverrideAttemptX != 0
		attemptX = OverrideAttemptX;
	else if !SuppressHorizontalInput {
		attemptX = StepSpeed;
		attemptX *= KeysOpposingX;
		attemptX *= SpeedMultipliers.X;
		attemptX *= (attemptX < 0 ? SpeedMultipliers.L : SpeedMultipliers.R);
	}
	if OverrideAttemptY != 0
		attemptY = OverrideAttemptY;
	else if !SuppressVerticalInput {
		attemptY = StepSpeed;
		attemptY *= KeysOpposingY;
		attemptY *= SpeedMultipliers.Y;
		attemptY *= (attemptY < 0 ? SpeedMultipliers.U : SpeedMultipliers.D);
	}
	
	// Add to attemptX and attemptY, if should
	if is_array(AddAttemptX)
		for (var i = 0; i < array_length(AddAttemptX); i += 1) {
			attemptX += AddAttemptX[i];
		}
	else if AddAttemptX
		attemptX += AddAttemptX
	if is_array(AddAttemptY)
		for (var i = 0; i < array_length(AddAttemptY); i += 1) {
			attemptY += AddAttemptY[i];
		}
	else if AddAttemptY
		attemptY += AddAttemptY
	
	// Circularize attemptX and attemptY, if should
	if DoCircularize {
		var d = point_direction(0, 0, attemptX, attemptY)
		if attemptX != 0
			attemptX = lengthdir_x(attemptX, d);
		if attemptY != 0
			attemptY = lengthdir_y(attemptY, d);
	}
	
	// Set locomotionX and locomotionY with Yaw applied, if should
	locomotionX = (lengthdir_x(-attemptX, Yaw-90) + lengthdir_x(attemptY, Yaw));
	locomotionY = (lengthdir_y(-attemptX, Yaw-90) + lengthdir_y(attemptY, Yaw));
    
	// Slow down if walking diagonally into walls, if should
	if SlowIntoWalls and (place_meeting_except(x + sign(attemptX), y, _colo, _xcep) or place_meeting_except(x, y+sign(attemptY), _colo, _xcep))
    {
		locomotionX = clamp(abs(locomotionX), 0, basespd+1) * sign(locomotionX);
		locomotionY = clamp(abs(locomotionY), 0, basespd+1) * sign(locomotionY);
	}
    
	// Round positioning, if above zero
	/*if PositionRounding > 0 {
		if !place_meeting_except(x + round_p(locomotionX, PositionRounding), y, _colo, _xcep) 
	        locomotionX = round_p(locomotionX, PositionRounding);
		if !place_meeting_except(x, y + round_p(locomotionY, PositionRounding), _colo, _xcep) 
	        locomotionY = round_p(locomotionY, PositionRounding);
	}*/
    
	//
	am_trying_to_locomoteX = locomotionX ? true : false;
	am_trying_to_locomoteY = locomotionY ? true : false;
	
	// Collision pardoning
	var _slinv = array_concat(_xcep, [o_noslope])
	if locomotionY == 0 and place_meeting_except(x+locomotionX, y, _colo, _slinv){
		var t = locomotionX;
		if !place_meeting_except(x+t, y+t, _colo, _xcep) 
            locomotionY = t;
		else if !place_meeting_except(x+t, y-t, _colo, _xcep) 
            locomotionY = -t;
	}
	else if locomotionY == 0 and place_meeting_except(x+sign(locomotionX), y, _colo, _slinv){
		var t = sign(locomotionX)
		if !place_meeting_except(x+t, y+t, _colo, _xcep) 
            locomotionY = t;
		else if !place_meeting_except(x+t, y-t, _colo, _xcep) 
            locomotionY = -t;
	}
    
	if locomotionX == 0 and place_meeting_except(x, y+locomotionY, _colo, _slinv){
		var t = locomotionY;
		if !place_meeting_except(x+t, y+t, _colo, _xcep) 
            locomotionX = t;
		else if !place_meeting_except(x-t, y+t, _colo, _xcep) 
            locomotionX = -t;
	}
	else if locomotionX == 0 and place_meeting_except(x, y+sign(locomotionY), _colo, _slinv){
		var t = sign(locomotionY);
		if !place_meeting_except(x+t, y+t, _colo, _xcep) 
            locomotionX = t;
		else if !place_meeting_except(x-t, y+t, _colo, _xcep) 
            locomotionX = -t;
	}
	
	if place_meeting_except(x+locomotionX, y+locomotionY, _colo, _xcep){
		var six = sign(locomotionX)
		var siy = sign(locomotionY)
		var bsx = (six*basespd)
		var bsy = (siy*basespd)
		var pfx = (six*0.5)
		var pfy = (siy*0.5)
        
		if !place_meeting_except(x+locomotionX, y+bsy, _colo, _xcep) locomotionY = bsy
		else if !place_meeting_except(x+bsx, y+locomotionY, _colo, _xcep) locomotionX = bsx
		else if !place_meeting_except(x+locomotionX, y+siy, _colo, _xcep) locomotionY = siy
		else if !place_meeting_except(x+six, y+locomotionY, _colo, _xcep) locomotionX = six
		else if !place_meeting_except(x+locomotionX, y+pfy, _colo, _xcep) locomotionY = pfy
		else if !place_meeting_except(x+pfx, y+locomotionY, _colo, _xcep) locomotionX = pfx
		else if !place_meeting_except(x+locomotionX, y, _colo, _xcep) locomotionY = 0
		else if !place_meeting_except(x, y+locomotionY, _colo, _xcep) locomotionX = 0
	}
	
	// Stick Iterations
	if !place_meeting_except(x+locomotionX, y+locomotionY, _colo, _xcep) {
		if locomotionX != 0 or (StickUseKeysToo and KeysOpposingX != 0) {
			if StickIterations.U > 0 {
				for (var i = 1; i <= StickIterations.U; i += 1) {
					if place_meeting_except(x+locomotionX, y+locomotionY-(i*2), _colo, _xcep)
					and !place_meeting_except(x+locomotionX, y+locomotionY-i, _colo, _xcep)
						locomotionY-=i;
				}
			}
			if StickIterations.D > 0 {
				for (var i = 1; i <= StickIterations.D; i += 1) {
					if place_meeting_except(x+locomotionX, y+locomotionY+(i*2), _colo, _xcep)
					and !place_meeting_except(x+locomotionX, y+locomotionY+i, _colo, _xcep)
						locomotionY+=i;
				}
			}
		}
		else if locomotionY != 0 or (StickUseKeysToo and KeysOpposingY != 0) {
			if StickIterations.L > 0 {
				for (var i = 1; i <= StickIterations.L; i += 1) {
					if place_meeting_except(x+locomotionX-(i*2), y+locomotionY, _colo, _xcep)
					and !place_meeting_except(x+locomotionX-i, y+locomotionY, _colo, _xcep)
						locomotionX-=i;
				}
			}
			if StickIterations.R > 0 {
				for (var i = 1; i <= StickIterations.R; i += 1) {
					if place_meeting_except(x+locomotionX+(i*2), y+locomotionY, _colo, _xcep)
					and !place_meeting_except(x+locomotionX+i, y+locomotionY, _colo, _xcep)
						locomotionY-=i;
				}
			}
		}
	}
	
	// Final collision check
	if place_meeting_except(x+locomotionX, y+locomotionY, _colo, _xcep) {
        locomotionX = 0; 
        locomotionY = 0;
    }
	
	// Move the player
	am_locomoting = false;
	if locomotionX != 0 {
        x += locomotionX; 
        am_locomoting = true;
    }
	if locomotionY != 0 and (!sliding or slide_vertical_allow) {
        y += locomotionY; 
        am_locomoting = true
    }
	
	// Round positioning, if above zero
	if PositionRounding > 0 {
		if !place_meeting_except(round_p(x, PositionRounding), y, _colo, _xcep) 
	        x = round_p(x, PositionRounding);
		if !place_meeting_except(x, round_p(y, PositionRounding), _colo, _xcep) 
	        y = round_p(y, PositionRounding);
	}
	
	failed_locomote_X = am_trying_to_locomoteX and locomotionX == 0 ? true : false;
	failed_locomote_Y = am_trying_to_locomoteY and locomotionY == 0 ? true : false;
	
	// Calculate actor direction, if enabled
	if DoCalculateActorDirection {
		var kl = attemptX<0 ? 1 : 0
		var kr = attemptX>0 ? 1 : 0
		var ku = attemptY<0 ? 1 : 0
		var kd = attemptY>0 ? 1 : 0
	
		if !variable_global_exists("loco_key_first") 
	        global.loco_key_first = -1;
	
		if !kl and global.loco_key_first == DIR.LEFT 
	        global.loco_key_first = -1;
		if !kr and global.loco_key_first == DIR.RIGHT 
	        global.loco_key_first = -1;
		if !ku and global.loco_key_first == DIR.UP 
	        global.loco_key_first = -1;
		if !kd and global.loco_key_first == DIR.DOWN 
	        global.loco_key_first = -1;
	
		if kl and kr and ku and kd 
	        global.loco_key_first = -1;
		else if global.loco_key_first == -1 and kr 
	        global.loco_key_first = DIR.RIGHT;
		else if global.loco_key_first == -1 and kl 
	        global.loco_key_first = DIR.LEFT;
		else if global.loco_key_first == -1 and ku 
	        global.loco_key_first = DIR.UP;
		else if global.loco_key_first == -1 and kd 
	        global.loco_key_first = DIR.DOWN;
		else if !kl and !kr and !ku and !kd 
	        global.loco_key_first = -1;
	
		if failed_locomote_X and failed_locomote_Y 
	        global.loco_key_first = -1;
	
		if global.loco_key_first == DIR.RIGHT and locomotionX < 0 
	        global.loco_key_first = DIR.LEFT;
		if global.loco_key_first == DIR.LEFT and locomotionX > 0 
	        global.loco_key_first = DIR.RIGHT;
		if global.loco_key_first == DIR.DOWN and locomotionY < 0 
	        global.loco_key_first = DIR.UP;
		if global.loco_key_first == DIR.UP and locomotionY > 0 
	        global.loco_key_first = DIR.DOWN;
		
		locomote_calculated_direction = global.loco_key_first != -1 ? global.loco_key_first : undefined;
	}
}