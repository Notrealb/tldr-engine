//draw_sprite_ext(spr_ui_menu_icon_smile, 0, 0, 0, 3, 3, 0, c_white, 1)

var bx = 0
var by = (o_camera.height*2)-100
draw_sprite_stretched_ext(spr_pixel, 0, bx-40, by, (o_camera.width*2)+40, 100+40, c_black, 0.6)


var txthead_noact = loc("txt_platact_headers_basic")[0]
var txtdesc_noact = loc("txt_platact_descriptions_basic")[0]

var txthead_act = loc("txt_platact_headers_basic")[2]
var txtdesc_act = loc("txt_platact_descriptions_basic")[2]

var txthead_check = loc("txt_platact_headers_basic")[1]
var txtdesc_check = loc("txt_platact_descriptions_basic")[1]


//
var txtdesc_recharge_0n = loc("txt_platact_descriptions_basic")[3]

var txtdesc_recharge_0n1y = loc("txt_platact_descriptions_basic")[4]
var txtdesc_recharge_01n = loc("txt_platact_descriptions_basic")[5]

var txtdesc_recharge_012n = loc("txt_platact_descriptions_extended")[0]
var txtdesc_recharge_01n2y = loc("txt_platact_descriptions_extended")[1]
var txtdesc_recharge_0n12y = loc("txt_platact_descriptions_extended")[2]

var txtdesc_recharge_0123n = loc("txt_platact_descriptions_extended")[3]
var txtdesc_recharge_012n3y = "p"
var txtdesc_recharge_01n23y = "p"
var txtdesc_recharge_0n123y = "p"

//
//string(txtdesc_recharge_0n, name)
//party_get_inst(global.party_names[0])


var headtxt = txthead_noact
var desctxt = txtdesc_noact


draw_set_font(loc_font("main"))
draw_text_scale(headtxt, bx + 20, by + 10)
draw_text_scale(desctxt, bx + 20, by + 40)

