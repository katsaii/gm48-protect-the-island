/// @desc Draw enemy.
var xpos = floor(x);
var ypos = floor(y);
part_system_drawit(partSys);
draw_witch(witch, blast, spr_enemy_broom, 0, xpos, ypos, -1, 1, c_white, 1, xspeed, yspeed);