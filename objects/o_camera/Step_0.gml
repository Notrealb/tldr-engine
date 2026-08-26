image_xscale = width * scale_x;
image_yscale = height * scale_y; 

if instance_exists(target) {
    if follow_x {
        if climb_check() {
            var dist = target.x - x_real;
            
            var d = abs(dist / 40);
            d = clamp(d, 0, 1);
            
            var spd = lerp(.5, 8, d) * sign(dist);
            var diff_dist = abs(dist) - abs(spd);
            
            if diff_dist < abs(spd)
                x = target.x;
            else 
                x = x_real + spd;
        }
        else
            x = target.x;
        
        x += offset_x;
        
        x_real = x; // save the real value before confining it
        if confined_on_x
            x = camera_confine_x(x);
    }
    if follow_y {
        if climb_check() {
            var dist = target.y - y_real;
            
            var d = abs(dist / 40);
            d = clamp(d, 0, 1);
            
            var spd = lerp(.5, 8, d) * sign(dist);
            var diff_dist = abs(dist) - abs(spd);
            
            if diff_dist < abs(spd)
                y = target.y;
            else 
                y = y_real + spd;
        }
        else
            y = target.y;
        
        y += offset_y;
		var pfyrise = instance_exists(o_dev_pf_controller) ? o_dev_pf_controller.camera_y_rise : 18
		y -= lerp(0, pfyrise, global.platforming_perspective);
        
        y_real = y; // save the real value before confining it
        if confined_on_y
            y = camera_confine_y(y);
    }
}
else {
    x_real = x;
    y_real = y;
}