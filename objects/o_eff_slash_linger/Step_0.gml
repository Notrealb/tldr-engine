if instance_exists(target) {
    x = target.x + xoff;
    y = target.y + yoff;
    image_index = target.image_index;
    
    if target.pf_attacktime <= 0
        instance_destroy();
}

timer ++;
if timer > life_max
    instance_destroy();