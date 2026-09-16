event_inherited()
collide = false

name = ""

// actor type
is_enemy = false
is_follower = false
is_in_battle = false
is_selected_for_battle = false
is_player = false
is_party = false

{ // player specific
	spd = (global.world == WORLD_TYPE.LIGHT ? 3 : 2);
	basespd = spd;
    
    auto_run = global.settings.AUTO_RUN
    noclip = false
	
	slide_vertical_allow = false // can move vertically while sliding
	diagonal = true // can move diagonally
	
	stepsounds = false
	stepsoundprefix = "snd_step"
	made_step = 0;
	stepgain = 1;
	
    spacing_default = 12;
    spacing_plat = 6;
	spacing = spacing_default
    
	playermask = spr_mask_15x8
	player_array_collisions = [];
	player_array_exceptions = [o_exception];
	
	player_movecode = "standard";
	player_followerhookcode_reset = function(){
		player_followerhookcode_a = function(){
			if get_leader().moving
				array_insert_cycle(record, 0, __new_record());
		};
		player_followerhookcode_b = function(){
			handle_walk_sprites_reset();
		};
	}
	player_followerhookcode_reset()

	
	pf_init = function() {
		player_platforming_movement_init()
	}
	pf_init()
}
{ // enemy specific
	chaser = false
	chasing = false
}
{ // actor variables
	follow = true;
    follow_target = get_leader();
    
	hurt = 0 // the timer of the sprite switch
    link_id = undefined
	
	autoheight = true // whether the height is automatically determined
	myheight = 0
	
	depth_override = undefined
	pos = 0
    pos_max = 0;
    
    interaction_code = function(){}
    interaction_args = []
    interactable_instances = []
}
{ // visual
	{ // sprites
		s_auto = true
		s_state = ""
		s_prefix = ""
		s_override = false
		s_dynamic = true
        
        // fallback move sprites
		s_move[DIR.UP] = spr_kris_up;
		s_move[DIR.DOWN] = spr_kris_down;
		s_move[DIR.LEFT] = spr_kris_left;
		s_move[DIR.RIGHT] = spr_kris_right;
        
        s_idle[DIR.UP] = undefined;
        s_idle[DIR.DOWN] = undefined;
        s_idle[DIR.LEFT] = undefined;
        s_idle[DIR.RIGHT] = undefined;
        
		s_hurt = spr_e_virovirokun_hurt
		s_ball = spr_kris_ball
		s_landed = spr_kris_landed
		s_slide = spr_kris_slide
		s_run_postfix = ""
        
        // climbing sprites
        s_climb = spr_kris_climb;
        s_climb_charge = spr_kris_climb_charge;
        s_climb_charge_left = spr_kris_climb_charge_left;
        s_climb_charge_right = spr_kris_climb_charge_right;
        s_climb_jump_left = spr_kris_climb_jump_left;
        s_climb_jump_right = spr_kris_climb_jump_right;
        s_climb_jump_up = spr_kris_climb_jump_up;
        s_climb_land_left = spr_kris_climb_land_left;
        s_climb_land_right = spr_kris_climb_land_right;
        s_climb_slip_fall = spr_kris_climb_slip_fall;
        
        // platforming sprites
        s_plat_idle = spr_plat_kris_idle;
        s_plat_jump_up = spr_plat_kris_jump_up;
        s_plat_jump_down = spr_plat_kris_jump_down;
        s_plat_land = spr_plat_kris_land;
        s_plat_run = spr_plat_kris_run;
        s_plat_run_stop = spr_plat_kris_run_stop;
        s_plat_turn = spr_plat_kris_turn;
        
        s_plat_hurt_ground = spr_plat_kris_hurt_ground;
        s_plat_hurt_air = spr_plat_kris_hurt_air;
        
        s_plat_slash_ground = spr_plat_kris_slash_ground;
        s_plat_slash_ground_fg = spr_plat_kris_slash_ground_fg;
        s_plat_slash_ground_hbx = spr_plat_kris_slash_ground_hbx;
		s_plat_slash_npoints_ground = [[snd_ui_cancel_small, 1], [snd_heavyswing, 5], [snd_ultraswing, 9]]
        
        s_plat_slash_air = spr_plat_kris_slash_air;
        s_plat_slash_air_fg = spr_plat_kris_slash_air_fg;
        s_plat_slash_air_hbx = spr_plat_kris_slash_air_hbx;
        s_plat_slash_air_land = spr_plat_kris_slash_air_land;
		s_plat_slash_npoints_air = [[snd_ui_cancel_small, 1], [snd_heavyswing, 5], [snd_ultraswing, 9], ["nul", 10]]
	
		s_idle_ispd = 1;
		s_walk_ispd = 1;
		s_run_ispd = 2;
        
        enum ACTOR_ANIMATIONS {
            IDLE,
            WALK,
            RUN,
        }
        s_current_animation = ACTOR_ANIMATIONS.IDLE;
        s_previous_animation = ACTOR_ANIMATIONS.IDLE;
	}
	
	s_drawer = function(_sprite, _index, _xx, _yy, _xscale, _yscale, _angle, _blend, _alpha) {
		draw_sprite_ext(_sprite, _index, 
			_xx, _yy, 
			_xscale, _yscale, 
			_angle, _blend, _alpha
		)
	}
    s_get_middle_y = function(relative = false) {
        if is_player && climb_check() 
            return y;
        return (relative ? 0 : y) - myheight/2;
    }
	
	handle_walk_sprites = function(){}
	handle_walk_sprites_standard = function(){
		// walk sprite speeds
		if moving && !is_in_battle && !is_enemy && s_dynamic && !s_override {
			if !startedmoving {
				startedmoving = true
		        last_walk_frame = cap_wraparound(last_walk_frame + 1, image_number);
		        last_walk_buffer = 12;
				image_index = last_walk_frame
			}
			if !running
				image_speed = s_walk_ispd
		}
		else if !is_in_battle && !is_enemy {
			startedmoving = false
			if floor(image_index) % 2 == 0 && !s_override && s_dynamic && s_current_animation != ACTOR_ANIMATIONS.IDLE
				s_current_animation = ACTOR_ANIMATIONS.IDLE;
		}

		// walk sprites
		if !is_in_battle && !is_enemy && s_dynamic && !s_override {
			if running && moving 
		        s_current_animation = ACTOR_ANIMATIONS.RUN;
		    else if moving
		        s_current_animation = ACTOR_ANIMATIONS.WALK;
		    switch s_current_animation {
		        default: // idle
		            var possible_idle = s_idle[dir];
		            if sprite_exists(possible_idle) { // switch to an idle sprite
		                sprite_index = possible_idle;
		                image_speed = s_idle_ispd;
		                if s_previous_animation != s_current_animation 
		                    image_index = 0;
		            }
		            else { // using only the walk sprites
		                sprite_index = s_move[dir];
		                image_speed = 0;
		                image_index = 0;
		            }
		            break;
		        case ACTOR_ANIMATIONS.WALK:
		            sprite_index = s_move[dir];
		            image_speed = s_walk_ispd;
		            break;
		        case ACTOR_ANIMATIONS.RUN:
		            sprite_index = asset_get_index_state(sprite_get_name(s_move[dir]), s_run_postfix);
		            image_speed = s_run_ispd;
		            break;
		    }
		}
	}
	handle_walk_sprites_reset = function(){ handle_walk_sprites = function(){handle_walk_sprites_standard();}}
	handle_walk_sprites_reset();
	
	snapping = 1 // 1 for none
	
	trail = false // afterimage
	flashing = false
	darken = 0
    darken_plat = 0;
	dim = 0
	sweat = false
	
	yoff = 0
	xoff = 0
	shake = 0
	angleoff = 0
	
    flash_color = c_white
	fsiner = 0 // flash siner
	flash = 0
    override_blend = undefined;
    
    // lighting
    lighting_highlight_enabled = true
    lighting_darken_enabled = true
    lighting_shadow_enabled = true
    
    // dark lighting library
    lb_dl_highlight_color = c_white
	
	can_reflect = true
	reflection_code = function() {
		var ret = image_yscale
		image_yscale = -image_yscale
		
		event_perform(ev_draw, ev_draw_normal)
		
		image_yscale = ret
	}
}
{ // internal variables
	dir = DIR.DOWN
    held_directions = []
	
	startedmoving = false
	moving = false
	sprname = ""
    player_run_timer = 0;
	
	run_away = false
	run_away_timer = 0
    
    freeze = 0
    
	running = false
	sliding = false
	prevsliding = false
	slideinst = noone
	
	init = false
	
	record = []
    record_targets = [];
    record_target = function(_var_name, _value_default, _refresh_method = method(self, function(_record) { 
        variable_instance_set(save_self, var_name, struct_get(_record, var_name)); 
    })) constructor {
        var_name = _var_name;
        save_self = other.id;
        
        value_default = _value_default;
        value_get = method(self, function(follow_target) {
            return variable_instance_get(follow_target, var_name);
        })
        
        refresh_method = _refresh_method;
    }
    
    dodge_outline_surf = -1
    dodge_mysoul = noone
    spawn_buffer = 4
    last_walk_frame = 0;
    last_walk_buffer = 0;
    alpha_mod = 1;
    
    queued_sprite = noone;
    queued_sprite_index = 0;
    queued_sprite_speed = 1;
    
    delta_x = 0;
    delta_y = 0;
	
	last_dir_left_right = dir
	last_dir_up_down = dir
}
{ // moveables
	moveable = true // the user-defined one, used in cutscenes and such. not touched by any of the systems in the engine by default
	moveable_dialogue = true
	moveable_menu = true
	moveable_move = true // actor_mover is moving it
	moveable_battle = true
	moveable_console = true
	moveable_save = true
	moveable_anim = true
    moveable_recruits = true
    moveable_shop = true
	moveable_array = []
	
	_checkmove = function() { // the main function that determines whether the player can move as of right now
		return moveable 
		&& moveable_dialogue
		&& moveable_menu
		&& moveable_move // actor_mover is moving it
		&& moveable_battle
		&& moveable_console
		&& moveable_save 
		&& moveable_anim 
        && moveable_recruits
        && moveable_shop
		&& (array_length(moveable_array) == 0 ? true : false)
		
		&& hurt == 0
        && spawn_buffer <= 0
		
		&& !global.console
        && global.player_moveable_global
		
		&& !instance_exists(o_ui_plataction)
	}
}

alarm[0] = 1 // initialize if not already initialized on the first frame

__initialize = function() {
    init = true
    
    if is_enemy 
    	if autoheight 
    		myheight = sprite_get_height(sprite_index)
    
    if is_party {
        event_user(2)
        
    	s_hurt = party_getdata(name, "battle_sprites").hurt
    	if autoheight 
    		myheight = party_getbattleheight(name)
    }
}

track_footsteps = false;
__step = function(index) {
    if moving {
        if stepsounds && index % 2 == 1
            audio_play(asset_get_index(stepsoundprefix + string(index div 2 + 1)));
        if instance_exists(o_lb_ripple_vision) && index div 2 == 0 {
            var xx = x + random_range(-4, 4);
            var yy = y + random_range(-4, 4);
            
            var inst = lb_ripple_create(xx, yy, 3, party_getdata(name, "iconcolor"),,,,,,,,, 1/40);
            inst.hspeed = locomotionX;
            inst.vspeed = locomotionY;
            
            inst = lb_ripple_create(xx, yy, 2, party_getdata(name, "iconcolor"),,,,,,,,, 1/40);
            inst.hspeed = locomotionX;
            inst.vspeed = locomotionY;
        }
    }
}
__new_record = method(self, function(_default = false) {
    var _s = {};
    for (var i = 0; i < array_length(record_targets); i ++) {
        struct_set(_s, record_targets[i].var_name, (_default ? record_targets[i].value_default : record_targets[i].value_get(follow_target)));
    }
    return _s;
});
__refresh_follow = function(_pos) {
    for (var i = 0; i < array_length(record_targets); i ++) {
        record_targets[i].refresh_method(record[_pos]);
    }
}

if !instance_exists(o_dodge_controller) 
	instance_create(o_dodge_controller);
if !instance_exists(o_eff_lighting_controller)
    instance_create(o_eff_lighting_controller);
if !instance_exists(o_dev_climb_controller)
    instance_create(o_dev_climb_controller);