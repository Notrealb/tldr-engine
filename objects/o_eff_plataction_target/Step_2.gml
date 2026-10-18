if !instance_exists(target) instance_destroy()
if !instance_exists(target) exit
var t = target;
var r = t.th;

vis = true
if global.platforming_perspective == 0
or !r.active
or !party_contains(r.char, true)
	vis = false;

depth = t.depth - 2;
if instance_exists(o_ui_plat_action)
	depth = o_ui_plat_action.depth + 2;

x = t.x;
y = t.y;

if r.color != -1
	image_blend = r.image_blend;
else if party_contains(r.char, true)
	image_blend = party_getdata(r.char, "color");


if instance_exists(o_ui_plat_action)
and selected
	hoverlerp = clamp(hoverlerp + 0.25, 0, 1);
else
	hoverlerp = clamp(hoverlerp - 0.25, 0, 1);

angle += (6 - (hoverlerp * 6));