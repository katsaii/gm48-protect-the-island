/// @desc Draw the title screen.
var cam = VIEW_CAM;
var cam_left = camera_get_view_x(cam);
var cam_top = camera_get_view_y(cam);
var cam_right = cam_left + camera_get_view_width(cam);
var cam_bottom = cam_top + camera_get_view_height(cam);
draw_set_font(fnt_script);
draw_set_valign(fa_top);
draw_set_halign(fa_center);
draw_text(mean(cam_left, cam_right), cam_top + 10, "Witch Whop");