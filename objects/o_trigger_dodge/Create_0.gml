event_inherited()

trigger_code = function() {}
trigger_exit_code = function() {
    var can_turn_off = true;
    with o_trigger_dodge {
        if id != other.id && triggered {
            can_turn_off = false;
            break;
        }
    }
    triggered = false;
    
    if can_turn_off {
   	    dodge_off()
    }
}
trigger_step_code = function() {
	with get_leader() {
		var check_exception = instance_place(x, y, o_trigger_dodge_exception)
		if check_exception {
			var check_exception_can = check_exception.can_trigger && ((check_exception.can_while_platforming and global.platforming_perspective) or (check_exception.can_while_not_platforming and global.platforming_perspective == 0))
			if check_exception_can
				dodge_off();
			else
				dodge_on();
		}
		else
			dodge_on();
	}
}