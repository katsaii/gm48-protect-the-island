/// @desc Initialise the window.
#macro VIEW_ID 0
#macro VIEW_CAM (view_camera[VIEW_ID])
#macro VIEW_DEFAULT_WIDTH (360) //(1440 div 4) // should scale up to be 1080p HD
#macro VIEW_DEFAULT_HEIGHT (270) //(810 div 4)
//window_set_caption(game_display_name + ": v" + string(GM_version));
window_set_min_width(VIEW_DEFAULT_WIDTH);
window_set_min_height(VIEW_DEFAULT_HEIGHT);
window_set_size_centre(VIEW_DEFAULT_WIDTH * 2, VIEW_DEFAULT_HEIGHT * 2);
application_surface_draw_enable(false);
windowWidth = -1;
windowHeight = -1;
viewWidth = -1;
viewHeight = -1;
pixelPerfect = false;
draw_set_font(fnt_default);