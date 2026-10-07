if target == noone exit
if target.hitstop >= 3 exit
if !ok {
	cooldown_timer_max = cooldown_timer
	ok = true
}

cooldown_timer--

var l = get_leader()

if !l.moveable_move or !l.moveable_dialogue
	hidehide = true
	
if hidehide
	image_alpha -= 0.1

if cooldown_timer <= 0
	instance_destroy()