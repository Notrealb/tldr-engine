if !(alivetime > 1) exit

var bx = 0
var by = (o_camera.height*2)-100
draw_sprite_stretched_ext(spr_pixel, 0, bx-40, by, (o_camera.width*2)+40, 100+40, c_black, 0.6)


var tHead_noact = loc("txt_platact_headers_basic")[0]
var tDesc_noactsavailable = loc("txt_platact_descriptions_basic")[0]
var tDesc_pressadirection = loc("txt_platact_descriptions_basic")[1]
var tDesc_enemyisguardingagainstattacks = loc("txt_platact_descriptions_basic")[2]

var tHead_act = loc("txt_platact_headers_basic")[1]
var tDesc_act = loc("txt_platact_descriptions_basic")[1]

var tHead_check = loc("txt_platact_headers_basic")[1]
var tDesc_check = loc("txt_platact_descriptions_basic")[1]


//
var tDesc_recharge_0n = loc("txt_platact_descriptions_basic")[3]

var tDesc_recharge_0n1y = loc("txt_platact_descriptions_basic")[4]
var tDesc_recharge_01n = loc("txt_platact_descriptions_basic")[5]

var tDesc_recharge_012n = loc("txt_platact_descriptions_extended")[0]
var tDesc_recharge_01n2y = loc("txt_platact_descriptions_extended")[1]
var tDesc_recharge_0n12y = loc("txt_platact_descriptions_extended")[2]

var tDesc_recharge_0123n = loc("txt_platact_descriptions_extended")[3]
var tDesc_recharge_012n3y = "p"
var tDesc_recharge_01n23y = "p"
var tDesc_recharge_0n123y = "p"

//
//string(tDesc_recharge_0n, name)
//party_get_inst(global.party_names[0])


var headtxt = ""
var desctxt = ""

if instance_exists(selection_inst) {
	if selection_inst.object_index == o_plat_action_node {
		headtxt = tHead_act;
		desctxt = "* ";//tDesc_act;
		
		if selection_inst.ui_header_override != -1
			headtxt = selection_inst.ui_header_override;
		//if selection_inst.ui_description_override != -1
		//	desctxt = selection_inst.ui_description_override;
	}
	else {
		headtxt = tHead_noact;
		desctxt = tDesc_noactsavailable;
		if acts_are_available
			desctxt = tDesc_pressadirection;
		if array_length(even_though_acts_are_available_we_cant_select_because) > 0
		and !but_there_are_available_acts_anyway_so_this_doesnt_matter
			desctxt = tDesc_enemyisguardingagainstattacks;
	}
}

draw_set_font(loc_font("main"));
draw_text_scale(headtxt, bx + 20, by + 10, undefined, c_grey);
draw_text_scale(desctxt, bx + 20, by + 40);

