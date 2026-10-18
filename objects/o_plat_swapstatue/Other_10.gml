/// @desc interacted
event_inherited()

if global.allow_use_platswap_statue {event_user(1)}
else {dialogue_start(loc("txt_platswapstatue_nofeather"))}