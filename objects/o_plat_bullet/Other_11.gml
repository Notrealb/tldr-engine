/// @description slashed
event_inherited();

hp--;
if destroy_when_no_hp and hp <= 0
	instance_destroy();
