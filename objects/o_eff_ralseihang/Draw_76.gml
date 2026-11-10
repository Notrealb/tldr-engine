if !instance_exists(target) or target.sprite_index != spr_plat_ralsei_hanging_back
	instance_destroy();
if !instance_exists(target)
	exit;
	
x = target.x
y = target.y + 21 + 13
depth = target.depth - 1

var l = get_leader();

var ontop = l.y <= y+3 and place_meeting(x, y - 4, l) 

if ontop {
	depth = l.depth - 20
	stepon = clamp(stepon + 0.2, 0, 3)
}else{
	stepon = clamp(stepon - 0.2, 0, 3);
}
image_index = floor(clamp(stepon, 0, 2))

if instance_exists(head) {
	head.x = x;
	head.y = y - (image_index == 0 ? 4 : (image_index == 1 ? 2 : 0));
	head.image_blend = image_blend;
	head.image_alpha = image_alpha;
	if sprite_index != spr_plat_ralsei_hanging_torso
		head.image_alpha = 0;
	head.depth = depth - 1;
	if l.x > x
		head.image_index = 0;
	else
		head.image_index = 1;
}

if ontop {
	if x != xprevious
		l.x += x - xprevious;
	if y != yprevious
		l.y += y - yprevious;
		
	l.y = y
	if instance_exists(head)
		head.image_index = 2;
}