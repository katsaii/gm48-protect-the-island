/// @desc Update movement.
var xdir = keyboard_direction(vk_left, vk_right);
var ydir = keyboard_direction(vk_up, vk_down);
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
    xspeed = 0;
    x = clamp(x, cam_left, cam_right);
}
if (y < cam_top || y > cam_bottom) {
    yspeed = 0;
    y = clamp(y, cam_top, cam_bottom);
}
wanda_spawn_particles();