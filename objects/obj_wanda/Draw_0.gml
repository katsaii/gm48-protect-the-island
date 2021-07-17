/// @desc Draw Wanda.
var xpos = floor(x);
var ypos = floor(y);
var img = current_time % 2000 > 1750;
part_system_drawit(partSys);
if (blast) {
    img = 3;
}
draw_witch(spr_wanda, img, spr_wanda_broom, 0, xpos, ypos, 1, 1, c_white, 1, xspeed, yspeed);