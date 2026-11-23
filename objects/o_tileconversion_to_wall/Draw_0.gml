if !debug or failure or !keep_after_making exit

var sw = sprite_get_width(sprite_index) //should be the tileset size
var sh = sprite_get_height(sprite_index) 
draw_sprite_ext(//floor, xywh
	spr_default_alt_4, 0,
	x,
	y - (sh * image_yscale),
	image_xscale,
	((sh - sw) / sw),
	0, c_white, .25
)
draw_sprite_ext(//wall, xywh
	spr_default_alt_5, 0,
	x,
	y - (sh * image_yscale) + (sh - sw),
	image_xscale,
	(((sh * image_yscale) - (sh - sw)) / sw),
	0, c_white, .25
)
CleanRectangle(//floor, x1y1x2y2
	x,
	y - (sh * image_yscale),
	x + (sw * image_xscale),
	y - ((sh * image_yscale) + (sh - sw))
)
.Blend(c_lime, .25)
.Draw()
CleanRectangle(//wall, x1y1x2y2
	x,
	y - (sh * image_yscale) + (sh - sw),
	x + (sw * image_xscale),
	y
)
.Blend(c_red, .25)
.Draw()