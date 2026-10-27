// Inherit the parent event
event_inherited();

image_xscale = 0
image_yscale = 0.1
audio_play(snd_enemy_appear)
animate(0, 1, 40, anime_curve.elastic_out, self, "image_xscale")
call_later(5, time_source_units_frames, function(){animate(0, 1.4, 40, anime_curve.elastic_out, self, "image_yscale")})
animate(0.1, 1, 20, anime_curve.linear, self, "actnodes_alpha")


plat_create_action_node(
	-5,
)
plat_create_action_node(
	5,
)



plat_create_action_node(//blocked
	-30,
	-40,
	undefined,undefined,undefined,undefined,
	true,
	true,
	false,
	false
)
plat_create_action_node(//superblocked
	0,
	-40,
	undefined,undefined,undefined,undefined,
	true,
	false,
	true,
	false
)
plat_create_action_node(//protected
	30,
	-40,
	undefined,undefined,undefined,undefined,
	true,
	false,
	false,
	true
)