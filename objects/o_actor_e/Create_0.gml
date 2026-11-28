event_inherited()

s_intro = spr_e_virovirokun_hurt
s_intro_spd = 0
s_frozen = undefined

is_enemy = true
chase_encounter = false
enemy_struct = {}

// idle_path, idle_path_spd, idle_path_autodir, sprite_facing_dir configured in variable difinitions
// chase_zone, chase_zone_auto, chase_dist and chase_spd are configured in variable definitions
// idle_path_autopos will make it so the enemy is snapped to the closest point on the path its linked to.
// idle_path_manualpos_optional will be the position on the path if the autopos is declined

chasing = false
notice_timer = -1
notice = false

pushback_objects = [o_eff_plat_slash_linger]
pushback = -1
pushbackprevious = pushback
pushback_exec = function(){if !audio_is_playing(snd_grab) audio_play(snd_grab)}
pushback_do_x = false
pushback_do_y = false
pushback_pushed_val = function(){return chase_spd * 2}

// visual animation
drawsiner = 0
// the encounter that would be initialized upon collision is in variable definitions
encounter_started = false

__start_chasing = function() {
    notice_timer = 0
    audio_play(snd_exclamation)
    
    if !is_undefined(idle_path)
        path_end()
    
    chase_encounter = true
}

xprev_real = 0
alarm[0] = 1