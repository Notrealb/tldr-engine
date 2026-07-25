event_inherited();

siner_xscale += axis_speed[0];
siner_yscale += axis_speed[1];
siner_angle += axis_speed[2];

axis_speed[0] = increment_towards(axis_speed[0], axis_stable_pos[0], axis_friction[0]);
axis_speed[1] = increment_towards(axis_speed[1], axis_stable_pos[1], axis_friction[1]);
axis_speed[2] = increment_towards(axis_speed[2], axis_stable_pos[2], axis_friction[2]);

if life > 15
    y += lerp(.5, 1, life/30);