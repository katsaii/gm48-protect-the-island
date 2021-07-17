/// @desc Draw the skyline.
var cam = VIEW_CAM;
var cam_left = camera_get_view_x(cam);
var cam_top = camera_get_view_y(cam);
var cam_width = camera_get_view_width(cam);
var cam_height = camera_get_view_height(cam);
var horizon = cam_height * 0.8;
var horizon_line = cam_top + horizon;
var sea_top = make_colour_rgb(221, 166, 172); // make_colour_rgb(105, 70, 77);
var sea_bottom = make_colour_rgb(133, 141, 177); // make_colour_rgb(221, 166, 172);
draw_sprite_stretched(spr_skyline, 0, cam_left, cam_top, cam_width, horizon);
draw_rectangle_colour(cam_left, horizon_line, cam_left + cam_width, cam_top + cam_height, sea_top, sea_top, sea_bottom, sea_bottom, false);
draw_line_colour(mouse_x - 30, mouse_y, mouse_x + 30, mouse_y, sea_top, sea_top);