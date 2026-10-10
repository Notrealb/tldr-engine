// Inherit the parent event
event_inherited();

var l = get_leader();
if !instance_exists(l) exit;
if (!must_be_grounded or (must_be_grounded and l.pf_grounded)) and delay_timer == 0 {
	l.pf_forceX += flingX;
	l.pf_forceY += flingY;
	delay_timer = delay_in_frames;
}