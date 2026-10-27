event_inherited();

// decrease hitstop and slash event timers
if hitstop_timer > 0
	hitstop_timer = max(0, hitstop_timer-1);
if hitstop_timer <= 0 and slash_event_cooldown_timer > 0
	slash_event_cooldown_timer = max(0, slash_event_cooldown_timer-1);