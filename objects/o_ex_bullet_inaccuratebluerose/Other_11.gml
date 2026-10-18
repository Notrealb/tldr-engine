/// @desc slashed
event_inherited();

audio_stop_sound(snd_punchweak);
audio_play(snd_punchweak,,,1)

with instance_create(o_eff_generic_animation, x, y, depth - 4) {
    sprite_index = spr_bnoelle_attackeff;
    //image_speed = 1.6;
	//image_xscale = 0.25;
	//image_yscale = 0.25;
}

instance_destroy();