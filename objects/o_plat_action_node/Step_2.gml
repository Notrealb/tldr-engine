// x, y, depth from host
if instance_exists(host) {
	x = host.x + xcorrect;
	y = host.y + ycorrect;
	depth = host.depth + depthcorrect;
}

// depth
if instance_exists(o_ui_plat_action)
	depth = o_ui_plat_action.depth + 2;

// visible
vis = true;
if global.platforming_perspective == 0
or !active
or !party_contains(char, true)
	vis = false;

// hovered lerp and angle
hoverlerp = selected ? clamp(hoverlerp + 0.25, 0, 1) : clamp(hoverlerp - 0.25, 0, 1);
angle += (6 - (hoverlerp * 6));

// colors and bwoosh-ripple spawning
if vis {
	node_color = (node_color != -1) ? node_color : (party_contains(char, true) ? party_getdata(char, "color") : c_white);
	bwoosh_color = (bwoosh_color != -1) ? bwoosh_color : (party_contains(char, true) ? party_getdata(char, "iconcolor") : c_white);

	bwooshtimer++;
	if vis
	and !(blocked or superblocked or protected or char_in_cooldown)
	and (bwooshtimer) % 60 == ((6767)*20) % 60
	{
		if bwoosh_method == -1
			bwoosh_inst = default_bwoosh_method();
		else
			bwoosh_inst = bwoosh_method();
	}
}

// alpha
if instance_exists(o_ui_plat_action)
	alpha = clamp(alpha + 0.1, 0, 1);
else
	alpha = clamp(alpha - 0.1, 0, 1);

if instance_exists(host) and variable_instance_exists(host, "actnodes_alpha")
	alpha *= host.actnodes_alpha;
