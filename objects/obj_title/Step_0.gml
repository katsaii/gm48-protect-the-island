/// @desc Update selection.
if not (visible) {
    exit;
}
var cam = VIEW_CAM;
var cam_left = camera_get_view_x(cam);
var cam_top = camera_get_view_y(cam);
var cam_right = cam_left + camera_get_view_width(cam);
var cam_bottom = cam_top + camera_get_view_height(cam);
var cam_xcentre = mean(cam_left, cam_right);
selection = obj_wanda.y > lerp(cam_top, cam_bottom, optionThreshold);
var make_selection = false;
with (obj_wanda_projectile) {
    if (x > cam_xcentre) {
        make_selection = true;
        break;
    }
}
if (make_selection) {
    if (selection == 0) {
        instance_create_layer(x, y, layer, obj_gameloop);
    } else {
        game_end();
    }
}