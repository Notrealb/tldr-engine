// Inherit the parent event
event_inherited();

image_xscale = 0
image_yscale = 0.1
audio_play(snd_enemy_appear)
animate(0, 1, 40, anime_curve.elastic_out, self, "image_xscale")
call_later(5, time_source_units_frames, function(){animate(0, 1.4, 40, anime_curve.elastic_out, self, "image_yscale")})
animate(0.1, 1, 20, anime_curve.linear, self, "actnodes_alpha")


//default tests
plat_create_action_node(
	0,
	-20,
	"susie"
)
plat_create_action_node(
	0,
	20,
	"ralsei"
)

//custom and cooldown tests
plat_create_action_node(
	-30,
	0,
	"kris",
	function(){
		audio_stop_sound(snd_plat_act_select)
		audio_play(snd_sparkle_glock, false, 0.9, random_range(0.7, 0.9))
		repeat(20) {
			var inst = instance_create(o_eff_magicstar, x - 30 + random_range(-10, 10), y + random_range(-10, 10), depth-1)
			inst.image_blend = choose(c_red, c_yellow, c_blue, c_aqua, c_fuchsia, c_lime, c_orange)
			inst.image_xscale = random_range(.5, 1)
			inst.image_yscale = random_range(.5, 1)
		}
		cooldownbar_create("kris", "TASTING THE SICK FRUIT JUICE")
	},
	undefined,
	function(){},
	"Sip", "Sip the sick fruit juice."
)
plat_create_action_node(
	-10,
	0,
	"susie",
	function(){
		audio_stop_sound(snd_plat_act_select)
		audio_play(snd_sparkle_glock, false, 0.9, random_range(0.7, 0.9))
		repeat(20) {
			var inst = instance_create(o_eff_magicstar, x - 10 + random_range(-10, 10), y + random_range(-10, 10), depth-1)
			inst.image_blend = choose(c_red, c_yellow, c_blue, c_aqua, c_fuchsia, c_lime, c_orange)
			inst.image_xscale = random_range(.5, 1)
			inst.image_yscale = random_range(.5, 1)
		}
		cooldownbar_create("susie", "TASTING THE SICK FRUIT JUICE")
	},
	undefined,
	function(){},
	"Sip", "I'LL sip the sick fruit juice!!"
)
plat_create_action_node(
	10,
	0,
	"ralsei",
	function(){
		audio_stop_sound(snd_plat_act_select)
		audio_play(snd_sparkle_glock, false, 0.9, random_range(0.7, 0.9))
		repeat(20) {
			var inst = instance_create(o_eff_magicstar, x + 10 + random_range(-10, 10), y + random_range(-10, 10), depth-1)
			inst.image_blend = choose(c_red, c_yellow, c_blue, c_aqua, c_fuchsia, c_lime, c_orange)
			inst.image_xscale = random_range(.5, 1)
			inst.image_yscale = random_range(.5, 1)
		}
		cooldownbar_create("ralsei", "TASTING THE SICK FRUIT JUICE")
	},
	undefined,
	function(){},
	"Sip", "I'll sip the sick fruit juice."
)
plat_create_action_node(
	30,
	0,
	"noelle",
	function(){
		audio_stop_sound(snd_plat_act_select)
		audio_play(snd_sparkle_glock, false, 0.9, random_range(0.7, 0.9))
		repeat(20) {
			var inst = instance_create(o_eff_magicstar, x + 30 + random_range(-10, 10), y + random_range(-10, 10), depth-1)
			inst.image_blend = choose(c_red, c_yellow, c_blue, c_aqua, c_fuchsia, c_lime, c_orange)
			inst.image_xscale = random_range(.5, 1)
			inst.image_yscale = random_range(.5, 1)
			cooldownbar_create("noelle", "TASTING THE SICK FRUIT JUICE")
		}
	},
	undefined,
	function(){},
	"Sip", "Can I sip the sick fruit juice..?"
)


plat_create_action_node(//blocked
	-30,
	-40,
	undefined,undefined,undefined,undefined,undefined,undefined,
	true,
	true,
	false,
	false
)
plat_create_action_node(//superblocked
	0,
	-40,
	undefined,undefined,undefined,undefined,undefined,undefined,
	true,
	false,
	true,
	false
)
plat_create_action_node(//protected
	30,
	-40,
	undefined,undefined,undefined,undefined,undefined,undefined,
	true,
	false,
	false,
	true
)