/// @desc Update movement.
var xdir = blast ? -1 : clamp(keyboard_direction(vk_left, vk_right) + keyboard_direction(ord("A"), ord("D")), -1, 1);
var ydir = clamp(keyboard_direction(vk_up, vk_down) + keyboard_direction(ord("W"), ord("S")), -1, 1);
xspeed = movement_iterate(xspeed, acc, frict, handling, xdir);
yspeed = movement_iterate(yspeed, acc, frict, handling, ydir);
x += xspeed;
y += yspeed;
var cam = VIEW_CAM;
var cam_left = camera_get_view_x(cam);
var cam_top = camera_get_view_y(cam);
var cam_right = cam_left + camera_get_view_width(cam);
var cam_bottom = cam_top + camera_get_view_height(cam);
if (x < cam_left || x > cam_right) {
    xspeed = x < cam_left ? 5 : -5;
    x = clamp(x, cam_left, cam_right);
}
if (y < cam_top || y > cam_bottom) {
    yspeed = y < cam_top ? 5 : -5;
    y = clamp(y, cam_top, cam_bottom);
}
wanda_spawn_particles(partSys);
blast = keyboard_check(ord("X")) || keyboard_check(vk_enter);
if (blastTimer == -1) {
    if (blast) {
        blastTimer = 1;
        audio_emitter_gain(shootEmitter, random_range(0.5, 0.6));
        audio_emitter_pitch(shootEmitter, random_range(0.8, 1.2));
        audio_play_sound_on(shootEmitter, snd_wanda_shoot, false, 1);
        with (instance_create_depth(x, y - 10 + random_range(-5, 5), depth, obj_wanda_projectile)) {
            speed = 10;
            direction = 2 * (other.xspeed + other.yspeed) + random_range(-2, 2);
            hspeed += other.xspeed;
            vspeed += other.yspeed;
            image_angle = direction;
        }
    }
} else {
    blastTimer -= blastCountdown;
    if (blastTimer < 0) {
        blastTimer = -1;
    }
}
hitTimer -= hitCounter;
if (hitTimer < 0) {
    hitTimer = 0;
}
if (hitTimer <= 0) {
    //var proj = instance_place(x, y, obj_enemy_projectile);
    //if (proj) {
    if (keyboard_check_pressed(vk_space)) {
        //instance_destroy(proj);
        hitTimer = 1;
        instance_create_layer(x, y, layer, obj_wanda_essence);
        audio_emitter_pitch(hurtEmitter, 1.5);
        audio_play_sound_on(hurtEmitter, snd_hit, false, 1);
    }
}
var velocity = map_range(point_distance(0, 0, xspeed, yspeed), 0, 20, 0, 1);
audio_emitter_gain(flyEmitter, lerp(0.1, 1, velocity));
audio_emitter_pitch(flyEmitter, lerp(0.75, 1.4, velocity));