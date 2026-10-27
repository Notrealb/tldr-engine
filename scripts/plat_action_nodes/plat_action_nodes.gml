function plat_create_action_node(
	_xcorrect = 0,
	_ycorrect = 0,
	_char = "susie",
	_effect = -1,
	_ui_header_override = -1,
	_ui_description_override = -1,
	_active = true,
	_blocked = false,
	_superblocked = false,
	_protected = false,
	_destroy_when_host_missing = true,
	_depthcorrect = -10,
	_node_color = -1,
	_bwoosh_color = -1,
	_bwoosh_method = -1,
	
	_inst = instance_create(o_plat_action_node),
	_host = self
) {
	inst = _inst;
	inst.host = _host;
	
	inst.xcorrect = _xcorrect;
	inst.ycorrect = _ycorrect;
	inst.char = _char;
	inst.effect = _effect;
	inst.ui_header_override = _ui_header_override;
	inst.ui_description_override = _ui_description_override;
	inst.active = _active;
	inst.blocked = _blocked;
	inst.superblocked = _superblocked;
	inst.protected = _protected;
	inst.destroy_when_host_missing = _destroy_when_host_missing;
	inst.depthcorrect = _depthcorrect;
	inst.node_color = _node_color;
	inst.bwoosh_color = _bwoosh_color;
	inst.bwoosh_method = _bwoosh_method;
}
/*
// Target setup
function plat_slashable_targetable(_x = x, _y = y, _char = "susie") constructor {
	targh._x = _x
	targh._y = _y
	targh.inst = instance_create(o_eff_plataction_target)
	targh.inst.target = self
	targh.char = _char
	targh.active = true
	
	targh.msg_inactive = loc("txt_platact_descriptions_basic")[0]
	targh.msg_blocked = loc("txt_platact_descriptions_basic")[2]
	
	targh.blocked = 0 //0:Not 1:Blocked 2:Superblocked?
	targh.protected = false //protected?
	targh.bwoosh = true //create hint ripples?
	targh.color = -1 //-1:use char color
	targh.effect = function(){} //ACT event
}

function plat_slashable_targetable_test() : plat_slashable_targetable() constructor {
	targh.effect = function(){
		audio_play(snd_ominous)
	}
}

function plat_slashable_targetable_rudebuster() : plat_slashable_targetable() constructor {
	targh.effect = function(){
		var pinst = party_get_inst(targh.char)
		var rbinst = instance_create(o_eff_rudebuster, pinst.x, pinst.y, targh.inst.depth - 12)
		rbinst.target_x = targh.inst.x
		rbinst.target_y = targh.inst.y
	}
}


// 
function plat_slashable() constructor {
	
}

function plat_slashable_bullet() : plat_slashable() constructor {
	
}

function plat_slashable_enemy() : plat_slashable() constructor {
	
}