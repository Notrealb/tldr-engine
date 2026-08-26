if !instance_exists(wall_parent) exit

x = wall_parent.x
xstart = wall_parent.xstart
ystart = __ystartoverride != undefined ? __ystartoverride : wall_parent.ystart

event_inherited();


image_xlength = wall_parent.image_xscale * sprite_get_width(wall_parent.sprite_index)
image_xscale = image_xlength / sprite_get_width(sprite_index)
image_alpha = wall_parent.image_alpha * global.platforming_perspective