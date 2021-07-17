/// @desc Initialise the scene.
#macro SCENE_ID
#macro SCENE_WIDTH (1440 div 4) // should scale up to be 1080p HD
#macro SCENE_HEIGHT (810 div 4)
window_set_min_width(VIEW_WIDTH);
window_set_min_height(VIEW_HEIGHT);
window_set_size_centre(VIEW_WIDTH * 2, VIEW_HEIGHT * 2);