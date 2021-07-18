/// @desc Check for window and camera resize.
application_views_mouse_update();
var view_last_width = viewWidth;
var view_last_height = viewHeight;
var view_cam = VIEW_CAM;
viewWidth = camera_get_view_width(view_cam);
viewHeight = camera_get_view_height(view_cam);
if (viewWidth != view_last_width || viewHeight != view_last_height) {
	view_set_xport(VIEW_ID, 0);
	view_set_yport(VIEW_ID, 0);
	view_set_wport(VIEW_ID, viewWidth);
	view_set_hport(VIEW_ID, viewHeight);
	//var port_pos = application_views_get_position();
	//surface_resize(application_surface, port_pos[2] - port_pos[0], port_pos[3] - port_pos[1]);
	surface_resize(application_surface, viewWidth, viewHeight);
	show_debug_message("resizing the view port [" + string(viewWidth) + ":" + string(viewHeight) + "]");
	exit; // surfaces aren't resized until the next frame, so this is required
}
var window_last_width = windowWidth;
var window_last_height = windowHeight;
windowWidth = window_get_width();
windowHeight = window_get_height();
if (windowWidth != window_last_width || windowHeight != window_last_height) {
	application_set_position_fixed(0, 0, windowWidth, windowHeight, !pixelPerfect);
	var app_pos = application_get_position();
	var app_x = app_pos[0];
	var app_y = app_pos[1];
	var app_width = app_pos[2] - app_x;
	var app_height = app_pos[3] - app_y;
	var app_surf_width = surface_get_width(application_surface);
	var app_surf_height = surface_get_height(application_surface);
	var app_scale_x = app_width / app_surf_width;
	var app_scale_y = app_height / app_surf_height;
	//display_set_gui_maximise(app_scale_x, app_scale_y, app_x, app_y);
	display_set_gui_position(app_scale_x / 3, app_scale_y / 3, app_x, app_y, app_x + app_width, app_y + app_height);
	show_debug_message("resizing the gui [" + string(app_width) + ":" + string(app_height) + "]");
	alarm[0] = 2; // it's gotta be 2, don't touch this whoever you are
	exit;
}