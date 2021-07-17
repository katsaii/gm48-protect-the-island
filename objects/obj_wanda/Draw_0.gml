/// @desc Draw Wanda.
var xpos = floor(x);
var ypos = floor(y);
var blink = current_time % 2000 > 1750;
draw_witch(spr_wanda, blink, spr_wanda_broom, 0, xpos, ypos);