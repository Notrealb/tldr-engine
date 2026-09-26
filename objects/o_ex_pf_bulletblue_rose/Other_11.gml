/// @desc slashed
event_inherited();

audio_stop_sound(snd_punchweak);
audio_play(snd_punchweak,,, 1.1);

for (var i = 0; i < 4; i++) { //This might be the wrong effect...
	var xx = x;
	var yy = y + (20 * i);
	var paperscraps = instance_create_depth(xx, yy, depth - 3, o_eff_generic);
	with (paperscraps) {
		sprite_index = spr_falling_petal;
		image_blend = merge_color(c_blue, c_aqua, 0.5);
		image_speed = random_range(0.2, 0.25);
		hspeed = random_range(-4, 4);
		vspeed = random_range(-14, -6);
		friction = 0.4;
		gravity = 0.4;
		gravity_direction = 270;
		life = 30
	}
}

with instance_create(o_eff_generic_animation, x, y, depth - 4) {
    sprite_index = spr_eff_plat_impact; //And this might be the wrong sprite
    image_speed = 1;
	image_xscale = 0.5;
	image_yscale = 0.5;
}

instance_destroy();