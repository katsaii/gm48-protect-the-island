/// @desc Update selection.
audio_emitter_gain(musicEmitter, musicFade);
if not (visible) {
    musicFade -= musicFadeCounter * 2;
    if (musicFade < 0) {
        musicFade = 0;
    }
    exit;
} else {
    musicFade += musicFadeCounter;
    if (musicFade > 1) {
        musicFade = 1;
    }
}
var cam = VIEW_CAM;
var cam_left = camera_get_view_x(cam);
var cam_top = camera_get_view_y(cam);
var cam_right = cam_left + camera_get_view_width(cam);
var cam_bottom = cam_top + camera_get_view_height(cam);
var cam_xcentre = mean(cam_left, cam_right);
selection = obj_wanda.y > lerp(cam_top, cam_bottom, optionThreshold);
if (selection == 0 && obj_wanda.y < lerp(cam_top, cam_bottom, creditThreshold)) {
    selection = 2 + (obj_wanda.x > mean(cam_left, cam_right));
}
if (!selectionSubmit && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("X")))) {
    selectionSubmit = true;
}
var make_selection = false;
with (obj_wanda_projectile) {
    if (x > cam_xcentre) {
        make_selection = true;
        break;
    }
}
if (selectionSubmit && make_selection) {
    selectionSubmit = false;
    switch (selection) {
    case 0:
        instance_create_layer(x, y, layer, obj_gameloop);
        break;
    case 1:
        game_end();
        break;
    case 2:
        url_open("http://nuxiigit.github.io/");
        break;
    case 3:
        url_open("https://www.deviantart.com/mashmerlow");
        break;
    }
}