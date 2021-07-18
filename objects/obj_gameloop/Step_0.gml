/// @desc Update timers.
if (gameOver) {
    global.hp = 0;
    if (fadeOut >= 1) {
        fadeOut = 1;
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("X"))) {
            instance_destroy();
        }
    } else {
        fadeOut += fadeOutCounter;
    }
    exit;
}
if (fadeIn < 1) {
    fadeIn += fadeInCounter;
    if (fadeIn > 1) {
        fadeIn = 1;
    }
}
global.hp -= hpDrain;
if (global.hp < 0) {
    global.hp = 0;
    gameOver = true;
}