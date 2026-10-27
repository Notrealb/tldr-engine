// Inherit the parent event
event_inherited();

audio_play(snd_glassbreak, false, 0.7, 0.7)

call_later(10*5, time_source_units_frames, function(){
	instance_create(o_ex_bullet_actionchalice, xstart, ystart)
})