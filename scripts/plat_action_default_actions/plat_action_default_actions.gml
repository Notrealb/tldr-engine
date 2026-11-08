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
		__cooldownbar_create(m, "RECHARGE")
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

function plat_action_susie_rudebuster_old(){
	var tgt = self.selection_inst
	var n = tgt.char
	var m = party_get_inst(n)
	cutscene_create()
	cutscene_set_variable(m, "s_override", true)
    cutscene_set_partysprite(n, "rudebuster");
	cutscene_set_variable(m, "image_speed", 1)
	cutscene_set_variable(m, "image_xscale", 1)
    cutscene_wait_until(function(_name) {
        return party_get_inst(_name).image_index >= 6
    }, [n])
    cutscene_func(function(tgt, m) {
		__cooldownbar_create(m, "RECHARGE")
		var inst = instance_create(o_eff_rudebuster_plat, m.x, m.y - 20, tgt.depth - 50)
		inst.target_x = tgt.x
		inst.target_y = tgt.y
		inst.enemy_o = tgt
		inst.dmg = 2
		inst.image_angle = point_direction(inst.x, inst.y, tgt.x, tgt.y) - 20
		inst.direction = inst.image_angle
    }, [tgt, m])
    cutscene_wait_until(function(m) {
        return m.image_index >= 14.1
    }, [m])
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
	
}