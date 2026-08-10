var gpp = global.platforming_perspective
var can_hit = global.allow_use_platswap_statue

//Draw the shine
shinetimer++
var xx = x+sine(.5, shake)
var shinescalex = (1.35 + (0.15 * sin(shinetimer * 0.03))) / 2
var shinescaley = (1.35 + (0.15 * cos(shinetimer * 0.015))) / 2
var shinefinalalpha = shinealpha * gpp * (0.5 + (0.15 * sin(shinetimer * 0.02)))
if gpp > 0.5 and can_hit {shinealpha += 0.1} else {shinealpha -= 0.1}
shinealpha = clamp(shinealpha, 0, 1)
draw_sprite_ext(spr_platswap_statue_light, 0, xx, y, shinescalex, shinescaley, 0, c_lime, shinefinalalpha)

// Draw the statue
pal_index = cap_wraparound(pal_index + 0.2, 6)
if !can_hit {pal_index = 7}
pal_swap_set(pal_sprite, pal_index, false)
draw_sprite(sprite_index, lerp(0, sprite_get_number(sprite_index)-0.001, gpp), xx, y)
pal_swap_reset()
