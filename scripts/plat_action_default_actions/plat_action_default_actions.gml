function plat_action_susie_rudebuster(){
	var tgt = self.selection_inst
	var n = tgt.char
	var m = party_get_inst(n)
	cutscene_create()
	cutscene_sleep(3)
	cutscene_set_variable(m, "s_override", true)
	//cutscene_set_variable(m, "image_xscale", 1)
	
    cutscene_set_partysprite(n, "attackready")
	cutscene_set_variable(m, "image_speed", 0)
	cutscene_sleep(4)
	
    cutscene_func(function(tgt, m) {
		cooldownbar_create(m, "RECHARGE")
		var inst = instance_create(o_eff_rudebuster_plat, m.x, m.y - 20, tgt.depth - 50)
		inst.target_x = tgt.x
		inst.target_y = tgt.y
		inst.enemy_o = tgt
		inst.dmg = 2
		inst.image_angle = point_direction(inst.x, inst.y, tgt.x, tgt.y) - 20
		inst.direction = inst.image_angle
    }, [tgt, m])
	
    cutscene_set_partysprite(n, "attack")
	cutscene_set_variable(m, "image_speed", 0)
	cutscene_set_variable(m, "image_index", 0)
	cutscene_sleep(4)
	
	cutscene_set_variable(m, "image_index", 1)
	cutscene_sleep(4)
	
	cutscene_set_variable(m, "image_index", 2)
	cutscene_sleep(3)
	
	cutscene_set_variable(m, "s_override", false)
	cutscene_play()	
}

function plat_action_kris_openmenu(){
	var tgt = self.selection_inst;
	if instance_exists(tgt.host) {
		if variable_instance_exists(tgt.host, "open")
			tgt.host.open = true;
		if variable_instance_exists(tgt.host, "open_sound")
			audio_play(tgt.host.open_sound);
	}
	var l = get_leader();
	if !instance_exists([o_ui_menu, o_ui_menu_lw]) 
    and !o_dodge_controller.dodge_mode
	and !l.sliding
	{
		if global.world == WORLD_TYPE.DARK instance_create(o_ui_menu);
		else if global.world == WORLD_TYPE.LIGHT instance_create(o_ui_menu_lw);
	}
	else {
		audio_stop_sound(snd_error);
		audio_play(snd_error,,,, 1);
	}
}

function plat_action_ralsei_hang(){
	var tgt = self.selection_inst
	var n = tgt.char
	var m = party_get_inst(n)
	
	if variable_instance_exists(m, "pahang_stage") {
		if m.pahang_stage == 0 {
			m.pahang_stage = 1
			m.pahang_node = tgt
		}
		else {
			m.pahang_stage = 8
			m.pahang_next_node = tgt
		}
	}
}
function plat_action_ralsei_hang__actor_create(){
	pahang_node = noone;
	pahang_ralsei_inst = noone;
	pahang_stage = 0;
	pahang_offsetx = 0;
	pahang_offsety = 0;
	pahang_node_trackx = 0;
	pahang_node_tracky = 0;
	pahang_next_node = noone;
	pahang_temp_stage_store = 0;
	pahang_floor_dist = 0;
	pahang_saved_depth = 0;
	pahang_fallspeed = 0;
}
function plat_action_ralsei_hang__actor_step(){
	if instance_exists(pahang_node)
		pahang_node.in_use = true;
}
function plat_action_ralsei_hang__actor_endstep(){
	if pahang_stage == 1 {
		plataction_alpha = clamp(plataction_alpha-.2, 0, 1);
		if plataction_alpha == 0
			pahang_stage = 2;
	}
	if pahang_stage == 2 {
		if instance_exists(pahang_next_node)
			pahang_node = pahang_next_node;
		pahang_next_node = noone;
	
		pahang_offsetx = 0;
		pahang_offsety = 0;
		cutscene_create()
		cutscene_animate(0, 1, 7, "linear", self, "plataction_alpha")
		cutscene_func(function(i){
			i.s_override = true
			i.image_xscale = 1
			i.sprite_index = spr_plat_ralsei_jump_down
			i.xoff = 10
			i.yoff = 0
		}, [self])
		cutscene_animate(0, 60, 7, "linear", self, "yoff")
		cutscene_sleep(7)
		cutscene_func(function(i){
			audio_play(snd_grab)
			i.sprite_index = spr_plat_ralsei_hanging_back
			i.xoff = 0
			i.yoff = 0
			i.pahang_ralsei_inst = instance_create(o_eff_ralseihang)
			pahang_ralsei_inst.target = self
		}, [self])
		cutscene_set_variable(self, "pahang_stage", 4)
		cutscene_play()
		pahang_stage = 3;
	}
	if pahang_stage == 4 {
	
		if (pahang_node != noone and !instance_exists(pahang_node))
		or InputPressed(INPUT_VERB.OTHER)
			pahang_stage = 5;
			
		if instance_exists(pahang_node) {
			if variable_instance_exists(pahang_node, "host")
			and instance_exists(pahang_node.host)
			and variable_instance_exists(pahang_node.host, "busy")
				pahang_node.host.busy = true;
		}
	}
	if pahang_stage == 5 or pahang_stage == 8 {
		pahang_temp_stage_store = pahang_stage;
		var qs = pahang_temp_stage_store == 8 //quickswitch
		cutscene_create()
		cutscene_func(function(i){
			i.sprite_index = spr_plat_ralsei_jump_down
			i.xoff = 10
			i.yoff = 70
		}, [self])
		cutscene_animate(60, qs ? 90 : 120, qs ? 7 : 14, "sine_in", self, "yoff")
		cutscene_animate(1, 0, 7, "linear", self, "plataction_alpha")
		cutscene_sleep(qs ? 7 : 14)
		cutscene_func(function(i, qs){
			i.plataction_alpha = 0;
			i.s_override = false;
			i.xoff = 0;
			i.yoff = 0;
			i.darken_plat = 0.5
			i.pahang_stage = (qs ? 2 : 7)
		}, [self, qs])
		cutscene_play()
		pahang_stage = 6
	}
	if pahang_stage == 7 {
		plataction_alpha = clamp(plataction_alpha+.2, 0, 1);
		if plataction_alpha == 1 {
			pahang_stage = 0;
			pahang_node = noone;
			pahang_next_node = noone;
		}
	}
	if pahang_stage == 9 {
		pahang_stage = 10;
		pahang_node = noone;
		pahang_next_node = noone;
		pahang_floor_dist = collision_line_point(x, y, x, y + 1000, o_plat_wall, true, true)[1]
		cutscene_create()
		cutscene_func(function(i){
			i.sprite_index = spr_plat_ralsei_falling
			var hiddenbar = cooldownbar_create(party_get_inst("ralsei"), "", infinity)	
			hiddenbar.visible = false
		}, [self])
		cutscene_animate(yoff, yoff + 10, 14, "linear", self, "yoff")
		cutscene_sleep(14)
		cutscene_set_variable(self, "pahang_stage", 11)
		cutscene_animate(4, 7, 10, "linear", self, "pahang_fallspeed")
		//cutscene_animate(yoff, 0, 10, "linear", self, "yoff")
		cutscene_party_follow(false, "ralsei")
		cutscene_play()
	}
	if pahang_stage == 11 {
		var bboxs = mask_index
		mask_index = sprite_index
		var col = get_leader().player_array_collisions
		var cget = move_and_collide_simpler(0, round(pahang_fallspeed), col)
		if cget {
			pahang_stage = 12
			sprite_index = spr_plat_ralsei_splat
			y = cget.bbox_top - 4//- (bbox_bottom - cget.bbox_top)
			audio_play(snd_splat)
			cutscene_create()
			cutscene_party_follow(false, "ralsei")
			cutscene_func(function(){
				cooldownbar_create(party_get_inst("ralsei"), "SPLAT", 30*3)	
			})
			cutscene_play()
		}
		mask_index = bboxs
		depth = pahang_saved_depth
	}
	for (var c = 0; c < instance_number(o_ui_plat_cooldown_bar); c++) {
		var f = instance_find(o_ui_plat_cooldown_bar, c)
		if f.target == party_get_inst("ralsei")
		and f.cooldown_timer == 1
		{
			cutscene_create()
			cutscene_set_variable(self, "pahang_stage", 0)
			cutscene_set_variable(self, "s_override", false)
			cutscene_party_interpolate()
			cutscene_party_follow(true, "ralsei")
			cutscene_play()
		}
	}
	if !array_contains([0, 1, 7, 11, 12], pahang_stage) {
		if instance_exists(pahang_node) {
			pahang_node_trackx = pahang_node.x + pahang_offsetx
			pahang_node_tracky = pahang_node.y + pahang_offsety
		}
		if instance_exists(pahang_node) and instance_exists(pahang_node.host)
			depth = pahang_node.host.depth - 1;
		x = pahang_node_trackx;
		y = pahang_node_tracky;
		pahang_saved_depth = depth;
	}
}