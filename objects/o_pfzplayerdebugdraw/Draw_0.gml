if global.platforming_perspective!=1 exit
if !instance_exists(get_leader()) exit
var l = get_leader()
if !variable_instance_exists(l, "plf_state") exit
if l.plf_state == undefined exit

var bbl = l.bbox_left
var bbt = l.bbox_top
var bbr = l.bbox_right
var bbb = l.bbox_bottom

draw_rectangle_ext(bbl, bbt, bbr, bbb, c_lime, 1)

//draw_line_colour(bbl, bbb, bbl, bbb-38, c_lime, c_red)


draw_line_colour(bbl, bbb, bbl, bbb+l.plf_SensorA_dist, c_lime, c_teal)


draw_line_colour(bbr, bbb, bbr, bbb+l.plf_SensorB_dist, c_aqua, c_green)



var n = "\n"
draw_text_scale(
+n+"plf_collide: "+string(l.plf_collide)
+n+"plf_SensorA_dist: "+string(l.plf_SensorA_dist)
+n+"plf_SensorB_dist: "+string(l.plf_SensorB_dist)
+n+"plf_WinningSensor: "+string(l.plf_WinningSensor)


, 10, 10, 0.5)
