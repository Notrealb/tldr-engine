selected = false;
char_in_cooldown = false;

// destroy if host is missing
if destroy_when_host_missing and !instance_exists(host) {
	instance_destroy();
	if instance_exists(bwoosh_inst)
		instance_destroy(bwoosh_inst);
}
