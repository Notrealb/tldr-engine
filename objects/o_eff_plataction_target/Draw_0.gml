if !instance_exists(target) exit
var t = target;
var r = t.th;

timer++;
if r.bwoosh
and vis
and (timer+rand) % 60 == ((6767)*20) % 60
	ripple = lb_ripple_create(x, y, 1, party_getdata(r.char, "iconcolor"), 20, ,, ,,,,, 0.04, self,,, depth - 20);
	// ^?????? how do you make small ripples

if !instance_exists(o_ui_plat_action) or !r.active exit

var aa = lerp(angle, (((floor(angle / 90) % 4) * 90) + 45) - (45 * 1), hoverlerp);
draw_sprite_ext(spr_plat_targetmode_circle, 0, x, y, 1, 1, 0, image_blend, 1);
draw_sprite_ext(spr_plat_targetmode_reticle, hoverlerp * 7, x, y, .5, .5, aa, image_blend, 1);
