event_inherited()
name = "noelle"
is_party = true

// platforming sprites
s_plat_idle = spr_bnoelle_idle;
s_plat_jump_up = spr_bnoelle_pray;
s_plat_jump_down = spr_bnoelle_attackready;
s_plat_land = spr_bnoelle_defeat;
s_plat_run = spr_noelle_right;
s_plat_run_stop = spr_bnoelle_victory;
s_plat_turn = spr_bnoelle_defend;

s_plat_hurt_ground = spr_bnoelle_hurt;
s_plat_hurt_air = spr_bnoelle_hurt;

s_plat_slash_ground = spr_bnoelle_attack;
s_plat_slash_ground_fg = spr_pixel;
s_plat_slash_ground_hbx = spr_bnoelle_attack;
s_plat_slash_npoints_ground = [[snd_whip_hard, 1]];
        
s_plat_slash_air = spr_bnoelle_attack;
s_plat_slash_air_fg = spr_pixel;
s_plat_slash_air_hbx = spr_bnoelle_attack;
s_plat_slash_air_land = spr_plat_kris_slash_air_land;
s_plat_slash_npoints_air = [[snd_whip_hard, 1]];