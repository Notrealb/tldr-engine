/// @description init record
var size = max(pos_max, pos) + 1;

record_targets = [
	//general
    new record_target("x", x),
    new record_target("y", y),
    new record_target("dir", dir),
    new record_target("running", false),
    new record_target("sliding", false),
	//drplatforming
    new record_target("pf_grounded", true),
    new record_target("pf_land", 0),
	new record_target("plf_SensorA_dist", 0),
	new record_target("plf_SensorB_dist", 0),
	new record_target("plf_WinningSensor", 0),
	new record_target("pf_ExampleDoCheapSlopePartyTilting", 0),
];
record = array_create_ext(size, function() { return __new_record(true) });