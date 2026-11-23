if use_pulpit_collision and !is_the_made_pulpit_copy_inst{
	solid_while_pf = false
	if pulpit_copy_inst == noone {
		pulpit_copy_inst = instance_copy(false)
		with pulpit_copy_inst {
			pulpit_copy_inst = noone
			is_the_made_pulpit_copy_inst = true
			solid_while_pf = true
			if other.use_pulpit_mask_also sprite_index = spr_plat_pulpit_mask
			image_xscale = (other.image_xscale * sprite_get_width(other.sprite_index)) / sprite_get_width(sprite_index)
			floor_drawer = "nothing"
			visible = false
			image_alpha = 0
		}
	}
}else if instance_exists(pulpit_copy_inst){
	instance_destroy(pulpit_copy_inst)
	pulpit_copy_inst = noone
}