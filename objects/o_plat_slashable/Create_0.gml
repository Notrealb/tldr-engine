// Inherit the parent event
event_inherited();

slashaction_code = function() {}
slashaction_args = []

hitstop = 0;
money = { //psuedo  -  get actual-defined money, eventually, however that's defined.
	darkdollers : 0,
	flowerycoins : 0
}

th = {
	inst : noone,
	active : false,
	blocked : 0,
	protected : false,
	bwoosh : true,
	char : "",
	color : -1,
	msg_inactive : "Can't act right now",
	msg_blocked : "The enemy is guarding against ACTs!",
	//msg_recharging : active.char+" is recharging.",
	effect : function(){}
}
