/// @description player input

if !instance_exists(o_pf_platswap_statue)
or !instance_exists(o_pf_wall)
	global.platforming_perspective=0;

if global.platforming_perspective == 1
	player_movecode = "drplatforming";


if player_movecode == "standard" {
	player_movecode_standard_move();
	player_movecode_standard_etc();
	player_followerhookcode_reset();
	handle_walk_sprites_reset();
}
else if !noclip and player_movecode == "drplatforming" {
	player_platforming_execute();
	player_followerhookcode_a = function(){
		if get_leader().moving
		or get_leader().pf_caterrecordtime > 0
			array_insert_cycle(record, 0, __new_record());
	};
	player_followerhookcode_b = function(){ 
		if y != get_leader().y
			get_leader().pf_caterrecordtime = 14;
		//if !get_leader().moving and pf_grounded and get_leader().pf_final_xchange != 0
		//	x += get_leader().pf_final_xchange;
		handle_walk_sprites = function(){
			actor_platforming_animate(pf_grounded, x - xprevious, y - yprevious, dir);
		}
	};
	handle_walk_sprites = function(){}
}
else {
	player_locomote_and_collide_except(noone, noone, 4 * (1+InputCheck(INPUT_VERB.CANCEL)));
	player_movecode_standard_etc();
	player_followerhookcode_reset();
	handle_walk_sprites_reset();
}
