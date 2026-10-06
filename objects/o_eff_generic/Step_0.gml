image_alpha = lerp(start_alpha, end_alpha, timer/life);
if start_scale != target_scale {
	image_xscale = lerp(start_scale, target_scale, timer/life);
	image_yscale = image_xscale;
}

if timer > life
    instance_destroy();

timer ++;