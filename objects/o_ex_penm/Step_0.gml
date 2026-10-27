x += sine(5, 2)
y += cosine(5, 2)

hitred = clamp(hitred-0.1, 0, 1)

image_blend = merge_color(c_red, c_white, clamp((hp/maxhp) - hitred, 0 ,1))