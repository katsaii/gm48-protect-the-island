/// @desc Update enemy position.
entryTimer += entryCounter;
if (entryTimer > 1) {
    entryTimer = 1;
}
hitTimer -= hitCounter;
if (hitTimer < 0) {
    hitTimer = 0;
}
blastTimer -= blastCounter;
if (blastTimer < 0) {
    blastTimer = 1;
}
var interp = easein(entryTimer);
angle += angleSpeed;
var path_x = targetX + lengthdir_x(amplitudeX, angle);
var path_y = targetY + lengthdir_y(amplitudeY, angle);
x = lerp(VIEW_RIGHT + 50, path_x, interp);
y = lerp(targetY, path_y, interp);
xspeed = x - xprevious;
yspeed = y - yprevious;
wanda_enemy_spawn_particles(partSys);
var proj = instance_place(x, y, obj_wanda_projectile);
if (hitTimer <= 0 && entryTimer > 0.25) {
    if (hp <= 0) {
        repeat (choose(3, 6, 9)) {
            instance_create_layer(x, y, layer, obj_enemy_essence);
        }
        instance_destroy();
    } else {
        if (proj) {
            instance_destroy(proj);
            hitTimer = 1;
            hp -= 1;
            instance_create_layer(x, y, layer, obj_enemy_essence);
            audio_play_sound_on(hurtEmitter, hp > 0 ? snd_hit : snd_enemy_defeat, false, 1);
        }
    }
} else if (proj) {
    instance_destroy(proj);
}