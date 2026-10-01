/// @desc slashed
event_inherited();

audio_stop_sound(snd_punchweak);
audio_play(snd_punchweak,,, 1.1);

var _y_center = (bbox_bottom + bbox_top) / 2;
with instance_create(o_eff_generic_animation, x, _y_center, depth) {
    sprite_index = spr_eff_plat_impact;
    image_speed = 1;
	depth = other._particle_depth
}

repeat (10) {
    with instance_create(o_ex_eff_papergrass_piece, x, _y_center, choose(150, depth - 50)) {
        start_scale = other.image_xscale;
        target_scale = other.image_xscale;
        
        direction = random_range(90 - 45, 90 + 45);
        speed = random_range(4, 7);
        friction = random_range(.2, .4);
        
        image_blend = other.image_blend;
		depth = other._particle_depth
    }
}

instance_destroy();