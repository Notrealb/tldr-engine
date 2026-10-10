event_inherited();
if dodgeaura_radius > 0 {
	if !instance_exists(dodgeaura_inst)
		dodgeaura_inst = instance_create(o_trigger_dodge_aura);
	dodgeaura_inst.target_inst = self;
	dodgeaura_inst.radius = dodgeaura_radius;
	dodgeaura_inst.can_while_platforming = dodgeaura_use_while_platforming;
	dodgeaura_inst.can_while_not_platforming = dodgeaura_use_while_not_platforming;
}
if hide_while_not_platforming and global.platforming_perspective < 1 {
	image_alpha = clamp(image_alpha - 0.1, 0, 1);
}else{
	image_alpha = clamp(image_alpha + 0.1, 0, 1);
}