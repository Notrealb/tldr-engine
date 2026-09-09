/// @description player input

if pf_enabled > 0 { // Platforming mode
	player_platforming_execute();
	//player_secondeditionplatforming_execute();
	//x_player_pf3_exec();
}
else { // Standard mode
	player_standard_movement_execute();
	player_standard_interaction_and_menutoggle_execute();
}

