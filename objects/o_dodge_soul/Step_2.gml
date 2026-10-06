depth = get_leader().depth - 10
x = get_leader().x
y = get_leader().y - get_leader().sprite_height/2 + 4
if global.platforming_perspective == 1
	y = get_leader().y - 16;