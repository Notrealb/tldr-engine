if global.platforming_perspective!=1 exit
if !instance_exists(get_leader()) exit
var l = get_leader()
if !variable_instance_exists(l, "plf_SensorA_dist") exit
//if l.plf_SensorA_dist == undefined exit

var bbl = l.bbox_left + 4
var bbt = l.bbox_top
var bbr = l.bbox_right - 4
var bbb = l.bbox_bottom

draw_rectangle_ext(bbl, bbt, bbr, bbb, c_lime, 1)

//draw_line_colour(bbl, bbb, bbl, bbb-38, c_lime, c_red)

draw_line_colour(bbl, bbb, bbl, bbb+l.plf_SensorA_dist, c_lime, c_teal)

draw_line_colour(bbr, bbb, bbr, bbb+l.plf_SensorB_dist, c_aqua, c_green)

draw_set_font(loc_font("main"))

var n = "\n"
draw_text_scale(
+n+"x: "+string(l.x)
+n+"y: "+string(l.y)
+n+"player_array_collisions: "+string(l.player_array_collisions)
+n+"plf_SensorA_dist: "+string(l.plf_SensorA_dist)
+n+"plf_SensorB_dist: "+string(l.plf_SensorB_dist)
+n+"plf_WinningSensor: "+string(l.plf_WinningSensor)
+n+"pf_hmove: "+string(l.pf_hmove)
+n+"pf_vspeed: "+string(l.pf_vspeed)
+n+"pf_final_xchange: "+string(l.pf_final_xchange)
+n+"pf_final_ychange: "+string(l.pf_final_ychange)
+n+"locomotionX: "+string(l.locomotionX)
+n+"locomotionY: "+string(l.locomotionY)
, camera_get_view_x(view_camera[0])+10, camera_get_view_y(view_camera[0])+10, 0.5)
