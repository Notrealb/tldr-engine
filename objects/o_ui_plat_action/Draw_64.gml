if !(alivetime > 1) exit

var bx = 0
var by = (o_camera.height * 2) - 100 - (instance_exists(o_ui_menu) ? ((60 - 17) * o_ui_menu.menuroll) : 0)
draw_sprite_stretched_ext(spr_pixel, 0, bx - 40, by, (o_camera.width * 2) + 40, 100 + 40 + 100, c_black, 0.6)

var headtxt = ""
var desctxt = ""
var overflowtxt = ""

acts_are_available = false;
even_though_acts_are_available_we_cant_select_because = [];
but_there_are_available_acts_anyway_so_this_doesnt_matter = false;
with o_plat_action_node {
	if onscreen(self, -6, undefined, true) 
	and vis
	{
		other.acts_are_available = true;
		if blocked
			array_push(other.even_though_acts_are_available_we_cant_select_because, "blocked")
		else if superblocked
			array_push(other.even_though_acts_are_available_we_cant_select_because, "superblocked")
		else if protected
			array_push(other.even_though_acts_are_available_we_cant_select_because, "protected")
		else if char_in_cooldown
			array_push(other.even_though_acts_are_available_we_cant_select_because, "char_in_cooldown")
		else
			other.but_there_are_available_acts_anyway_so_this_doesnt_matter = true;
	}
}
if instance_exists(selection_inst) {
	if selection_inst.object_index == o_plat_action_node {
		headtxt = party_getdata(selection_inst.char, "plataction_default_action_title_front")
		if selection_inst.ui_header_override != -1
			headtxt += selection_inst.ui_header_override;
		else
			headtxt += party_getdata(selection_inst.char, "plataction_default_action_title")
		
		desctxt = loc("txt_platact_descriptions_basic")[6]//'*'
		var t = loc("txt_platact_headers_basic")[6]//'Use'
		t = party_getdata(selection_inst.char, "plataction_default_action_dialogue")
		if selection_inst.ui_description_override != -1
			t = selection_inst.ui_description_override;
		t = "{auto_pauses(0)}" + "{speed(.5)}" + t
		string_insert("{speed(1)}", t, 3)
		__txt_desc_typer_make(t);
	}
	else {
		__txt_desc_typer_clear();
		headtxt = loc("txt_platact_headers_basic")[0];//'No act'
		desctxt = loc("txt_platact_descriptions_basic")[0];//'No acts available'
		if acts_are_available
			desctxt = loc("txt_platact_descriptions_basic")[1];//'Press a direction'
		
		var __pa_wl = []
		for (var i = 0; i < instance_number(o_plat_action_node); ++i) {
			var inst = instance_find(o_plat_action_node, i);
		
			if plat_get_action_node_is_selectable(inst, selection_inst, true)
			and !array_contains(__pa_wl, inst.char)
				array_push(__pa_wl, inst.char);
		}
		if array_length(__pa_wl) > 0 {
			var __pca = []
			var __pnca = []
			for (var i = 0; i < party_length(true); i++) {
				var a = [global.party_names[i], false]
				if instance_exists(o_ui_plat_cooldown_bar) {
					for (var c = 0; c < instance_number(o_ui_plat_cooldown_bar); c++) {
						if a[0] == instance_find(o_ui_plat_cooldown_bar, c).target.name
							a[1] = true
					}
				}
				if a[0] == get_leader().name
				or !array_contains(__pa_wl, a[0])
					{}
				else if a[1] == true
					array_push(__pnca, a[0]);
				else
					array_push(__pca, a[0]);
			}
			if array_length(__pnca) > 0 {
				// Get localization strings
				var ___EVERYONEn = loc("txt_platact_descriptions_extended")[7]//special: Everyone is recharging.
				var ___0n        = loc("txt_platact_descriptions_basic")[3]
				var ___0n1y      = loc("txt_platact_descriptions_basic")[4]//example: {0} is recharging. {1} is  ready.
				var ___01n       = loc("txt_platact_descriptions_basic")[5]
				var ___012n      = ___EVERYONEn //loc("txt_platact_descriptions_extended")[0]
				var ___01n2y     = loc("txt_platact_descriptions_extended")[1]//example: {0} and {1} are recharging. {2} is ready.
				var ___0n12y     = loc("txt_platact_descriptions_extended")[2]
				var ___0123n     = ___EVERYONEn //loc("txt_platact_descriptions_extended")[3]
				var ___012n3y    = loc("txt_platact_descriptions_extended")[4]
				var ___01n23y    = loc("txt_platact_descriptions_extended")[5]
				var ___0n123y    = loc("txt_platact_descriptions_extended")[6]
				
				// Determine which to use
				var str = "Erm."
				var yes = array_length(__pca)
				var no = array_length(__pnca)
				switch (yes) {
					case 0:
						switch (no) {
						case 1: str = ___0n;      break;
						case 2: str = ___01n;     break;
						case 3: str = ___012n;    break;
						case 4: str = ___0123n;   break;
						}
					break;
					case 1:
						switch (no) {
						case 1: str = ___0n1y;    break;
						case 2: str = ___01n2y;   break;
						case 3: str = ___012n3y;  break;
						}
					break;
					case 2:
						switch (no) {
						case 1: str = ___0n12y;   break;
						case 2: str = ___01n23y;  break;
						}
					break;
					case 3:
						switch (no) {
						case 1: str = ___012n3y;  break;
						}
					break;
				}

				// Put together the text, and replace the {#}s with the actual names in the pca/pnca arrays.
				var r = [str]
				var bump = 0
				for (var i = 0; i < array_length(__pnca); i++) { 
					array_push(r, ["{" + string(i) + "}", party_getname(__pnca[i])])
					bump++
				}
				for (var i = 0; i < array_length(__pca); i++) { 
					array_push(r, ["{" + string(i + bump) + "}", party_getname(__pca[i])])
				}
				desctxt = method_call(string_replace_many, r)
				
				// Split any new lines into the overflow text, because, with more than two party members besides the leader, the text gets too long.
				var p = string_split(desctxt, "\n", false, 1)
				if array_length(p) >= 2 {
					desctxt = p[0]
					overflowtxt = "      " + p[1]
				}
				
				// Debug; See who is in the pa_wl and pca and pcna arrays
				//draw_text_scale("ALLOW: " + string(__pa_wl) + "\n" + string(yes) + " Y: " + string(__pca) + "\n" + string(no) + " N: " + string(__pnca), bx + 20, by + 40 - 140);
			}
		}
		if array_contains(even_though_acts_are_available_we_cant_select_because, "protected")
			desctxt = loc("txt_platact_descriptions_basic")[2];//'Enemy is guarding against acts'
	}
}


draw_set_font(loc_font("main"));

if selection_inst.object_index == o_plat_action_node {
	draw_text_scale(headtxt, bx + 20, by + 10, undefined, c_white);
	draw_text_scale(string_split(headtxt, "-->")[0], bx + 20, by + 10, undefined, party_getdata(selection_inst.char, "color"));
}
else draw_text_scale(headtxt, bx + 20, by + 10, undefined, c_grey);

draw_text_scale(desctxt, bx + 20, by + 40);
if __cfg_DrawOverflowDescriptionReadyText
	draw_text_scale(overflowtxt, bx + 20, by + 75, 1);

