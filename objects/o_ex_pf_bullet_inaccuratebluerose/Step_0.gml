//if (!global.pause_plat)
    sinertimer++;

x = xstart + (h_amp * sin((h_freq * 0.05 * sinertimer) + (h_offset * 2 * pi)));
y = ystart + (v_amp * cos((v_freq * 0.05 * sinertimer) + (v_offset * 2 * pi)));



//if (!global.pause_plat)
    spikestimer += (spikesspeed * 0.2);