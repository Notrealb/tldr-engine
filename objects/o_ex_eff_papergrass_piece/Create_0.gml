event_inherited();
life = 40;
start_alpha = 2;

var max_speed = 30;
axis_speed = [random(max_speed), random(max_speed), random(10) * choose(-1, 1)];
axis_friction = array_create(3, 1);
axis_stable_pos = array_create(3, 0)

siner_xscale = random(30);
siner_yscale = random(30);
siner_angle = random(360);

image_speed = 0;
image_index = irandom(image_number - 1);