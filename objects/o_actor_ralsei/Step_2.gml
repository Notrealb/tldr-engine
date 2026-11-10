// Inherit the parent event
event_inherited();

if pahang_stage == 1 {
	plataction_alpha = clamp(plataction_alpha-.2, 0, 1);
	if plataction_alpha == 0
		pahang_stage = 2;
}

if pahang_stage == 2 {
	pahang_offsetx = 0;
	pahang_offsety = 0;
	cutscene_create()
	cutscene_animate(0, 1, 7, "linear", self, "plataction_alpha")
	cutscene_func(function(i){
		i.s_override = true
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
	
if pahang_stage == 5 {
	cutscene_create()
	cutscene_func(function(i){
		i.sprite_index = spr_plat_ralsei_jump_down
		i.xoff = 10
		i.yoff = 70
	}, [self])
	cutscene_animate(60, 120, 14, "sine_in", self, "yoff")
	cutscene_animate(1, 0, 8, "linear", self, "plataction_alpha")
	cutscene_sleep(14)
	cutscene_func(function(i){
		i.plataction_alpha = 0;
		i.s_override = false;
		i.xoff = 0;
		i.yoff = 0;
		i.darken_plat = 0.5
		i.pahang_stage = 7
	}, [self])
	cutscene_play()
	pahang_stage = 6
}

if pahang_stage == 7 {
	plataction_alpha = clamp(plataction_alpha+.2, 0, 1);
	if plataction_alpha == 1 {
		pahang_stage = 0;
		pahang_node = noone;
	}
}
	
if !array_contains([0, 1, 7], pahang_stage) {
	if instance_exists(pahang_node) {
		pahang_node_trackx = pahang_node.x + pahang_offsetx
		pahang_node_tracky = pahang_node.y + pahang_offsety
	}
	if instance_exists(pahang_node) and instance_exists(pahang_node.host)
		depth = pahang_node.host.depth - 1;
	x = pahang_node_trackx;
	y = pahang_node_tracky;
}
