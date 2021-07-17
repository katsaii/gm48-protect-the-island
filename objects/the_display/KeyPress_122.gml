/// @desc Toggle fullscreen.
var enable = !window_get_fullscreen();
show_debug_message((enable ? "entering" : "exiting") + " fullscreen mode");
window_set_fullscreen(enable);