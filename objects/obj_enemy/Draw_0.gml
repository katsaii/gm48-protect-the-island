/// @desc Draw enemy.
var xpos = floor(x);
var ypos = floor(y);
part_system_drawit(partSys);
if (hitTimer > 0.75 && current_time % 150 > 100) {
    gpu_set_blendmode(bm_add);
}
draw_witch(witch, blast, spr_enemy_broom, 0, xpos, ypos, -1, 1, c_white, hp <= 0 ? hitTimer : 1, xspeed, yspeed);
gpu_set_blendmode(bm_normal);
for (var i = 0; i < hp; i += 1) {
    draw_sprite(spr_heart, 0, xpos - (hp - 1) * 4 + i * 8, ypos - 20);
}
//draw_sprite(spr_enemy_hitbox, 0, xpos, ypos);