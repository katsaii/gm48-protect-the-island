/// @desc Draw the skyline.
var cam = VIEW_CAM;
var cam_left = camera_get_view_x(cam);
var cam_top = camera_get_view_y(cam);
var cam_width = camera_get_view_width(cam);
var cam_height = camera_get_view_height(cam);
var horizon = cam_height * 0.8;
var horizon_line = cam_top + horizon;
draw_sprite_stretched(spr_skyline, 0, cam_left, cam_top, cam_width, horizon);
draw_rectangle_colour(cam_left, horizon_line, cam_left + cam_width, cam_top + cam_height, SKYLINE_TOP, SKYLINE_TOP, SKYLINE_BOTTOM, SKYLINE_BOTTOM, false);
//draw_line_colour(mouse_x - 30, mouse_y, mouse_x + 30, mouse_y, sea_top, sea_top);
wanda_sealine_spawn_particles(partSys, cam_left, horizon_line, cam_left + cam_width, cam_top + cam_height);
cloudTimer -= cloudCountdown;
islandTimer -= islandCountdown;
if (cloudTimer < 0) {
    cloudTimer = 1;
    wanda_skyline_spawn_particles(partSys, cam_left, cam_top, cam_left + cam_width, cam_top + cam_height);
}
if (islandTimer < 0) {
    islandTimer = 1;
}
var padding = sprite_get_width(spr_island) * 2;
draw_sprite(spr_island, 0, lerp(cam_left - padding, cam_left + cam_width + padding, islandTimer), horizon_line);
part_system_drawit(partSys);