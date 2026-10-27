/// @desc slashed
event_inherited();

audio_play(snd_punchweak, false, 1, 1, true)

with instance_create(o_eff_generic_animation, x, y, depth - 4) {
    sprite_index = spr_bnoelle_attackeff;
}

instance_destroy();