var check_canmove = _checkmove() && !climb_check();
var x_move = 0
var y_move = 0

if is_enemy && freeze > 0 {
    image_speed = 0
    sprite_index = s_hurt
    
    exit
}
if spawn_buffer > 0
    spawn_buffer --

if !init
	exit

// player movement
if is_player && check_canmove {
	event_user(3) // Player interactions event
}

// if i am a follower and i am following the leader
else if follow && is_follower && instance_exists(follow_target) {
	script_execute_ext(get_leader().player_followerhookcode_a);
	__refresh_follow(pos);
	script_execute_ext(get_leader().player_followerhookcode_b);
}
else if sliding {
	if instance_exists(slideinst) && !place_meeting(x, y, slideinst){
		sliding = false
		y -= global.slide_speed
	}
	y += global.slide_speed
}

// set moving for non-players, and then make sure the player isn't set as moving when they shouldn't be
if !is_player {
	moving = false;
	if ((abs(x - xprevious) > 0 || abs(y - yprevious) > 0) and !is_in_battle and !is_enemy) or sliding
		moving = true;
}
else if s_override or !s_dynamic or is_in_battle or !moveable{
	moving = false;
}

// handle walk sprites
handle_walk_sprites();

// darken in certain conditions
if is_follower {
	var plat_should_darken = (global.platforming_perspective > .5 && !(instance_exists(o_enc) || instance_exists(o_enc_anim)));
    darken_plat = increment_towards(darken_plat, (plat_should_darken ? .5 : 0), .05);
}

{ // timers and siners
	if hurt > 0
		hurt --
	
	if run_away && is_enemy && hurt > 0
		sweat = true
	else
		sweat = false
	
	if flashing 
		fsiner ++
    
    if trail {
        var inst = afterimage(.05)
        inst.depth += 10
    }
    
    if last_walk_buffer > 0
        last_walk_buffer --;
    else 
        last_walk_frame = 0;
}
		
// overworld battle
if o_dodge_controller.dodge_mode && is_player {
	if !instance_exists(dodge_mysoul)
		dodge_mysoul = instance_create(o_dodge_soul, x, y - sprite_height/2 + 4, depth, {caller: id})
}
