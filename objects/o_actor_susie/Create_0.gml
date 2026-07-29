event_inherited()
name = "susie"
is_party = true

// platforming sprites
s_plat_idle = spr_plat_susie_idle;
s_plat_jump_up = spr_plat_susie_jump_up;
s_plat_jump_down = spr_plat_susie_jump_down;
s_plat_land = spr_plat_susie_land;
s_plat_run = spr_plat_susie_run;
s_plat_run_stop = spr_plat_susie_run_stop;
s_plat_turn = spr_plat_susie_turn;

s_plat_hurt_ground = spr_bsusie_hurt;
s_plat_hurt_air = spr_bsusie_hurt;

s_plat_slash_ground = spr_bsusie_attack;
s_plat_slash_ground_fg = spr_pixel;
s_plat_slash_ground_hbx = spr_bsusie_attack;
s_plat_slash_npoints_ground = [[snd_ultraswing, 1]];
        
s_plat_slash_air = spr_bsusie_attack;
s_plat_slash_air_fg = spr_pixel;
s_plat_slash_air_hbx = spr_bsusie_attack;
s_plat_slash_air_land = spr_plat_kris_slash_air_land;
s_plat_slash_npoints_air = [[snd_ultraswing, 1]];