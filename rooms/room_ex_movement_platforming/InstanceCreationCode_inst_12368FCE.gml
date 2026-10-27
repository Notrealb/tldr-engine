execute_code_slashed = function() {
	o_dev_plat_controller.default_perspectiveangle+=0.1
	o_plat_wall.perspectiveangle = o_dev_plat_controller.default_perspectiveangle
	if get_leader().pf_grounded
		get_leader().y -= 4;
}