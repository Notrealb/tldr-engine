timer ++


/////

image_alpha = clamp(image_alpha + 0.25, 0, 1);

if (instance_exists(o_enc))
{
    image_alpha -= 0.5;
    
    if (image_alpha <= 0)
    {
        instance_destroy();
        exit;
    }
}

if hitstop_timer > 0
{
    if (_hspeed == -999)
    {
        _hspeed = hspeed;
        _vspeed = vspeed;
    }
    
    hspeed = 0;
    vspeed = 0;
    exit;
}
else if (_hspeed != -999)
{
    hspeed = _hspeed;
    vspeed = _vspeed;
    _hspeed = -999;
}

/////

if (instance_exists(enemy_o))
{
    target_x = enemy_o.x;
    target_y = enemy_o.y;
}
else
{
    target_x = x + (hspeed * 2);
    target_y = y + (vspeed * 2);
}

//
dir = point_direction(x, y, target_x, target_y);
var angdif = angle_difference(dir, direction) / max(4 - ((timer / 60) * 4), 1);
    
if (timer > 30 && abs(angdif) > 90)
{
    x = target_x;
    y = target_y;
}
    
if (timer < 40)
    direction += angdif;
    
image_angle = direction;

/*

var dir = point_direction(x, y, target_x, target_y);
direction += (angle_difference(dir, direction) / 4);
image_angle = direction
*/

instance_create(o_eff_rudebuster_trail, x, y, depth + 10, {
    image_index, image_angle, image_blend, image_alpha
})


if point_distance(x, y, target_x, target_y) < 20 {
    x = target_x
    y = target_y
    
	if enemy_o.host with enemy_o.host {
		hitstop_timer = hit_stop_frames;
		event_user(1);
		slash_event_cooldown_timer = slash_event_cooldown;
	}
	
    audio_play(snd_rudebuster_hit)
    
    for (var i = 45; i < 360; i += 90) {
        instance_create(o_eff_rudebuster_exp, x, y, depth, {
            speed: 4.5,
            image_angle: i,
			image_speed: 2,
        })
        instance_create(o_eff_rudebuster_exp, x, y, depth, {
            speed: 4.75,
            image_angle: i,
			image_speed: 2,
        })
    }
    instance_destroy()
}