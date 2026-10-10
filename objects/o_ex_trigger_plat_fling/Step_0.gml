// Inherit the parent event
event_inherited();

delay_timer = increment_towards(delay_timer, 0, 1);
if delay_timer == 0 and triggered == true and retriggerable and retriggerable_within_trigger {
	triggered = false;
	can_trigger = true;
}