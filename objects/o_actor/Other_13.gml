/// @description player input

if !instance_exists(o_plat_swap_statue)
or !instance_exists(o_plat_wall)
	global.platforming_perspective=0;

if global.platforming_perspective == 1
	player_movecode = "drplatforming";

if player_movecode == "standard" { // Deltarune Standard
	player_movecode_standard_move();
	player_movecode_standard_etc();
	player_followerhookcode_reset();
	handle_walk_sprites_reset();
}
else if !noclip and player_movecode == "drplatforming" { // Deltarune Platforming
	player_platforming_execute();
	player_followerhookcode_a = function(){
		if get_leader().moving
		or get_leader().pf_caterrecordtime > 0
			array_insert_cycle(record, 0, __new_record());
	};
	player_followerhookcode_b = function(){ 
		if y != get_leader().y
			get_leader().pf_caterrecordtime = 14;
		handle_walk_sprites = function(){
			actor_platforming_animate(x - xprevious, y - yprevious, dir);
		}
	};
	handle_walk_sprites = function(){}
}
else { // Noclipping
	player_locomote_and_collide_except(noone, noone, 4 * (1+InputCheck(INPUT_VERB.CANCEL)));
	player_movecode_standard_etc();
	player_followerhookcode_reset();
	handle_walk_sprites_reset();
}
