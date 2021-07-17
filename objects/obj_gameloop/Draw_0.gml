/// @desc Draw island.
var angle = current_time * 0.1;
var dx = lengthdir_x(2, angle);
var dy = lengthdir_y(2, angle);
var xpos = floor(VIEW_CENTRE_X + dx)
var ypos = floor(VIEW_CENTRE_Y + dy);
draw_sprite(spr_main_island, 0, xpos, ypos);
var hp = 20;
draw_set_alpha(0.9);
draw_circle_colour(xpos, ypos, hp + 0.5 * dsin(angle), CBlue.DEEP_SKY, CYellow.REKINDLED, false);
draw_circle_colour(xpos, ypos, hp + 2 + 0.5 * dsin(angle), CBlue.DEEP_SKY, CYellow.REKINDLED, true);
draw_set_alpha(1);