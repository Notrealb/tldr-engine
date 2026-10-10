execute_code_slashed = function() {
    cutscene_create()
	cutscene_player_canmove(false)
	cutscene_party_follow(false)
	
	for (var i = 0; i < party_length(true); ++i) {
	    cutscene_actor_move(party_get_inst(global.party_names[i]), [
            new actor_movement(700 - (party_length(true) -  1) * 15 + i*30, 500, 1),
		], false)
	}
	cutscene_wait_until(function() {
        return !instance_exists(o_actor_mover)
    })
	
	cutscene_player_canmove(true)
	
	cutscene_party_follow(true)
	cutscene_party_interpolate()
	cutscene_play()
}