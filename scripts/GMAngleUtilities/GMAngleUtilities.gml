// via
// https://github.com/dicksonlaw583/GMAngleUtilities
// https://forum.gamemaker.io/index.php?threads/gm-angle-utilities.120915/
// All functions from the library have been grouped together into this script.

#macro SPIN_CCW 1
#macro SPIN_TO 0
#macro SPIN_CW -1

///@func angle_delta(a, b, [spin])
///@param {Real} a The starting angle.
///@param {Real} b The ending angle.
///@param {Real} [spin] (Optional, default=0): The direction to check for difference in. -1=clockwise, 0=closest approach, 1=counter-clockwise
///@return {Real}
///@pure
///@desc Return the difference in angle from a to b.
function angle_delta(a, b, spin=0) {
    gml_pragma("forceinline");
    return (angle_difference(b, a)+sign(spin)*360) mod 360;
}

///@func angle_clamp(v, a, b, [spin])
///@param {Real} v The angle to clamp
///@param {Real} a The first angle
///@param {Real} b The second angle
///@param {Real} [spin] (Optional, default=0): The direction to run. -1=clockwise, 0=closest approach, 1=counter-clockwise
///@return {Real}
///@pure
///@desc Return the angle t restricted to the range between angles a and b inclusively. 
function angle_clamp(v, a, b, spin=0) {
    var mid = a+angle_delta(a, b, spin)/2;
    var ad = abs(mid-a);
	return mid+clamp(angle_delta(mid, v), -ad, ad);
}

///@func angle_closest_spin(a, b)
///@param {Real} a The starting angle.
///@param {Real} b The ending angle.
///@return {Real}
///@pure
///@desc Return the spin of the closest rotation from a to b (-1 for clockwise, 1 for counter-clockwise, 0 if a is the same direction as b).
function angle_closest_spin(a, b) {
    gml_pragma("forceinline");
    return sign(angle_difference(b, a));
}

///@func angle_equals(a, b, [tolerance])
///@param {Real} a The first angle
///@param {Real} b The second angle
///@param {Real} [tolerance] (Optional, default=0) The comparison tolerance in degrees
///@return {Bool}
///@pure
///@desc Return whether angles a and b point in the same direction (within the given tolerance in degrees).
function angle_equals(a, b, tolerance=0) {
    gml_pragma("forceinline");
    return abs(angle_difference(b, a)) <= tolerance;
}

///@func angle_is_between(v, a, b, [spin])
///@param {Real} v The angle to check
///@param {Real} a The first angle
///@param {Real} b The second angle
///@param {Real} [spin] (Optional, default=0): The direction to run. -1=clockwise, 0=closest approach, 1=counter-clockwise
///@return {Bool}
///@pure
///@desc Return whether the angle t is between a and b inclusively.
function angle_is_between(v, a, b, spin=0) {
    var ad = angle_delta(a, b, spin)/2;
	return abs(angle_delta(a+ad, v)) <= abs(ad);
}

///@func angle_lerp_towards(a, b, [t], [tolerance], [spin])
///@param {Real} a Original angle in degrees
///@param {Real} b Target angle in degrees
///@param {Real} [t] (Optional, default=0.1) Fraction of the difference to cover
///@param {Real} [tolerance] (Optional, default=1) The difference in degrees under which to snap directly
///@param {Real} [spin] (Optional, default=0): The direction to check for difference in. -1=clockwise, 0=closest approach, 1=counter-clockwise
///@return {Real}
///@pure
///@desc Return the new angle after a moves the given fraction t of the distance to b. If the distance is lower than the tolerance, move directly to b.
function angle_lerp_towards(a, b, t=0.1, tolerance=1, spin=0) {
    var ad = angle_delta(a, b, spin);
    return (abs(ad) <= tolerance) ? b : (a+t*ad);
}

///@func angle_unlerp(v, a, b, [spin])
///@param {Real} v The angle to work with.
///@param {Real} a The starting angle of the range.
///@param {Real} b The ending angle of the range.
///@param {Real} [spin] (Optional, default=0): The direction to run the range in. -1=clockwise, 0=closest approach, 1=counter-clockwise
///@return {Real}
///@pure
///@desc Return the interpolation factor that would give v in the angular range from a to b.
function angle_unlerp(v, a, b, spin=0) {
    gml_pragma("forceinline");
    return angle_delta(a, v, spin)/angle_delta(a, b, spin);
}

///@func angle_midpoint(a, b, [t], [spin])
///@param {Real} a The first angle
///@param {Real} b The second angle
///@param {Real} [t] (Optional, default=0.5) The interpolation factor from a (0) to b (1)
///@param {Real} [spin] (Optional, default=0): The direction to run. -1=clockwise, 0=closest approach, 1=counter-clockwise
///@return {Real}
///@pure
///@desc Return the midpoint angle between a and b with the given interpolation factor.
function angle_midpoint(a, b, t=0.5, spin=0) {
    gml_pragma("forceinline");
    return a+t*angle_delta(a, b, spin)
}

///@func angle_normalize(v)
///@param {Real} v The angle to normalize
///@return {Real}
///@pure
///@desc Normalize the given angle in degrees to the [0, 360) range.
function angle_normalize(v) {
    gml_pragma("forceinline");
    return v-floor(v/360)*360;
}

///@func angle_step_towards(a, b, [step], [spin])
///@param {Real} a Original angle in degrees
///@param {Real} b Target angle in degrees
///@param {Real} [step] (Optional, default=1): Step size in degrees
///@param {Real} [spin] (Optional, default=0): The direction to check for difference in. -1=clockwise, 0=closest approach, 1=counter-clockwise
///@return {Real}
///@pure
///@desc Return the new angle after a moves towards b for up to the given step size.
function angle_step_towards(a, b, step=1, spin=0) {
    var ad = angle_delta(a, b, spin);
	return (abs(ad) <= step) ? b : (a+sign(ad)*step);
}

///@func angle_to_sector(angle, [sectors], [baseAngle])
///@param {Real} angle The angle in degrees
///@param {Real} [sectors] (Optional, default=4) The number of sectors
///@param {Real} [baseAngle] (Optional, default=0) The base angle for the sector system
///@return {Real}
///@desc Return the sector number that the given angle lies in (0 to N-1). Sectors start centered at the base angle and rotate counter-clockwise.
///
/// Example: The ranges for the default (4 sectors based at 0) are: -45-45 (0), 45-135 (1), 135-225 (2), 225-315 (3)
function angle_to_sector(angle, sectors=4, baseAngle=0) {
    return ((angle_difference(angle+180/sectors, baseAngle)+360) div (360/sectors)) mod sectors;
}

///@func sector_to_angle(sector, [sectors], [baseAngle])
///@param {Real} sector The sector number
///@param {Real} [sectors] (Optional, default=4) The number of sectors
///@param {Real} [baseAngle] (Optional, default=0) The base angle for the sector system
///@return {Real}
///@desc Return the central angle for the given sector number (0 to N-1). Sectors start centered at the base angle and rotate counter-clockwise.
function sector_to_angle(sector, sectors=4, baseAngle=0) {
    return baseAngle+360*(sector/sectors);
}
