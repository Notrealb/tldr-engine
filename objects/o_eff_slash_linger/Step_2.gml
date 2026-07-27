if instance_exists(target) {
    x = target.x + target.xoff + sine(.5, target.shake);
    y = target.y + target.yoff + lerp(0, -2, global.platforming_perspective);
	
    image_speed = target.image_speed
	if array_contains([target.s_plat_slash_air, target.s_plat_slash_ground], target.sprite_index) {
		image_index = target.image_index;
	}else{
		image_index += 0.5;
		if target.pf_land and sprite_index == spr_plat_kris_slash_air_fg and image_index > 11 { //bandaid
			visible = false
		}
	}
    
    if target.pf_attacktime <= 0 and !target.pf_land
        instance_destroy();
}

timer ++;
if timer > life_max
    instance_destroy();