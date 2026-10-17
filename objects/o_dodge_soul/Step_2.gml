var l = get_leader()
depth = l.depth - 10
x = l.x
y = l.y - l.sprite_height/2 + 4
if global.platforming_perspective == 1
	y = l.y - 16;