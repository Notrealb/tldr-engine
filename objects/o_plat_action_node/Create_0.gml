xcorrect = 0
ycorrect = 0
char = "susie"
effect = function(){}
ui_header_override = -1
ui_description_override = -1
active = true
blocked = false
superblocked = false
protected = false
destroy_when_host_missing = true
depthcorrect = 0
node_color = -1
bwoosh_color = -1
bwoosh_method = -1

host = noone

draw_myself = true
selected = false
bwooshtimer = irandom_range(0,9999)
hoverlerp = 0
angle = 0
vis = false
default_bwoosh_method = function(){return lb_ripple_create(x, y, 1, bwoosh_color, 20, ,, ,,,,, 0.04, self,,, depth - 20);}
bwoosh_inst = noone
alpha = 0
char_in_cooldown = false