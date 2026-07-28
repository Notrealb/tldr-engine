if sound_on_frame != -1 
	sound_on_frame = -1

if instance_exists(o_ui_plataction)
	global.plataction_fade = min(global.plataction_fade + 0.2, 1);
else
	global.plataction_fade = 0;
