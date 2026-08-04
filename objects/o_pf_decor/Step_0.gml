var abc_a = wall_parent.y - (wall_parent.floor_backlength_in_tiles * wall_parent.tilesize * (1-((1-wall_parent.perspectiveangle)*global.platforming_perspective)))
var abc_s = wall_parent.__y_while_not_pf - (wall_parent.floor_backlength_in_tiles * wall_parent.tilesize)
var def = (ystart - abc_s) / (wall_parent.__y_while_not_pf - abc_s)
y = lerp(abc_a, wall_parent.y, def)
//depth = wall_parent.depth + 