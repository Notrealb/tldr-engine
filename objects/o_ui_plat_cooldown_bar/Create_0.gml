target = noone
hidehide = false
text = "COOLDOWN"
cooldown_timer = 90
cooldown_timer_max = cooldown_timer
ok = false
barwidth = 30

__char_in_cooldown_returned = false;
__set_nodes_cooldown = function() {
	with o_plat_action_node {
		if party_get_inst(char) == other.target
			char_in_cooldown = true;
		other.__char_in_cooldown_returned = char_in_cooldown;
	}
	return __char_in_cooldown_returned;
}