if busy
	dropval = clamp(dropval + rate, 0, 1)
else
	dropval = clamp(dropval - rate, 0, 1)

xoff = 0
yoff = anime_curve_lerp(0, dist, dropval, curve)

busy = false;