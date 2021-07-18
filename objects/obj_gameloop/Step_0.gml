/// @desc Update timers.
audio_emitter_gain(musicEmitter, musicFade);
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
    musicFade -= musicFadeCounter * 2;
    if (musicFade < 0) {
        musicFade = 0;
    }
    exit;
} else {
    var prev_music = musicFade;
    musicFade += musicFadeCounter * 0.5;
    if (prev_music < 0 && musicFade >= 0) {
        audio_play_sound_on(musicEmitter, bgm_gameplay, true, 100);
    }
    if (musicFade > 1) {
        musicFade = 1;
    }
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