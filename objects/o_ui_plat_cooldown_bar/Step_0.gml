with o_plat_action_node {
	if party_get_inst(char) == other.target
		char_in_cooldown = true;
}

if target == noone exit
if target.hitstop_timer >= 3 exit
if !ok {
	cooldown_timer_max = cooldown_timer;
	ok = true;
}

cooldown_timer--;

var l = get_leader();

if !l.moveable_move or !l.moveable_dialogue
	hidehide = true;
	
if hidehide
	image_alpha -= 0.1;

if cooldown_timer <= 0
	instance_destroy();
