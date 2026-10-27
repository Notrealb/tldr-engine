// Inherit the parent event
event_inherited();

audio_stop_sound(snd_punchweak);
audio_play(snd_punchmed,,,random_range(0.8,1))
audio_stop_sound(snd_spawn_weaker)
call_later(1, time_source_units_frames, function(){audio_play(snd_spawn_weaker,,,random_range(0.8,1))})

hitred = 1