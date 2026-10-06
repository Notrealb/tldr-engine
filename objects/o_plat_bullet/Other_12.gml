/// @description collision

get_leader().pf_final_xchange = 0
get_leader().pf_hmove = 0
get_leader().pf_final_ychange = 0
get_leader().pf_vspeed = 0
get_leader().pf_forceY += fling_y
get_leader().pf_forceX += (abs(fling_x_abs) * (fling_dir<0 ? -1 : (fling_dir>0 ? 1 : (x>get_leader().x ? -1 : 1))))

party_attack_all(dmg, o_enc)
o_dodge_soul.i_frames = 38
instance_destroy()

