for (var i = 0; i < 8; i++)
{
    var angle = 45 * i;
    var len = 7 + (2 * sin(spikestimer + (i * 0.5 * spikesoffset)));
    var spr = ((i % 2) == 0) ? spr_ex_bullet_blue_rose_thorn_straight : spr_ex_bullet_blue_rose_thorn_diagonal;
    draw_sprite_ext(spr, 0, x + (floor((lengthdir_x(len, angle) * image_xscale) / 2) * 2), y + (floor((lengthdir_y(len, angle) * image_yscale) / 2) * 2), image_xscale, image_yscale, floor(angle / 90) * 90, image_blend, image_alpha);
}

draw_self();