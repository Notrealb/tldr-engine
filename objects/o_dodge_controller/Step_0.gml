// make the dodge effects fade in and fade out
if !dodge_override {
	if dodge_mode
		dodge_alpha = lerp(dodge_alpha, 1, global.platforming_perspective ? 0.16 : .2)
	else 
		dodge_alpha = lerp(dodge_alpha, 0, global.platforming_perspective ? 0.1 : .15)
    
	dodge_alpha = clamp(dodge_alpha, 0, 1)
}

// change values to use based on platforming perspective
dodge_base_alpha = lerp(dodge_base_ow_alpha, dodge_base_pf_alpha, global.platforming_perspective)
dodge_darken = lerp(dodge_ow_darken, dodge_pf_darken, global.platforming_perspective)