/// @desc Update timers.
if (gameOver) {
    hp = 0;
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
hp -= hpDrain;
if (hp < 0) {
    hp = 0;
    gameOver = true;
}