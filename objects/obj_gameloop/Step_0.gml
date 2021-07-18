/// @desc Update timers.
audio_emitter_gain(musicEmitter, musicFade);
if (gameOver) {
    global.hp = 0;
    if (gameRestart) {
        gameRestartTimer -= gameRestartCounter;
        if (gameRestartTimer < -0.25) {
            instance_destroy();
            with (obj_enemy) {
                hp = 0;
            }
        }
    } else {
        if (fadeOut >= 1) {
            fadeOut = 1;
            if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("X"))) {
                gameRestart = true;
            }
        } else {
            fadeOut += fadeOutCounter;
            if (fadeOut >= 1) {
                fadeOut = 1;
            }
        }
    }
    audio_emitter_gain(gameOverEmitter, fadeOut * max(gameRestartTimer, 0));
    audio_emitter_gain(crumbleEmitter, 1 - fadeOut);
    musicFade -= musicFadeCounter * 3;
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
var prev_pool = global.hpPool;
global.hpPool = max(0, global.hpPool - hpRecover);
global.hp += prev_pool - global.hpPool;
if (global.hp > hpMax) {
    global.hp = hpMax;
}
if (global.hp < 0) {
    global.hp = 0;
    gameOver = true;
    audio_play_sound_on(gameOverEmitter, bgm_finish_bad, true, 100);
} else {
    audio_emitter_gain(crumbleEmitter, (10 - global.hp) / 5);
}
if (fadeIn > 0.9 && !instance_exists(obj_enemy)) {
    show_debug_message("starting a new wave");
    // types of wave:
    // - single centre enemy
    // - two enemties going in circles
    // - three enemies in a triangle formation, the middle enemy in front
    // - enemy circling another enemy
    switch (3) {//(choose(0, 1, 2, 3)) {
    case 0:
        with (instance_create_layer(VIEW_RIGHT - 50, VIEW_CENTRE_Y, layer, obj_enemy)) {
            amplitudeX = 10;
            amplitudeY = VIEW_HEIGHT / 2.5;
        }
        break;
    case 1:
        var amp = VIEW_HEIGHT / 5.5;
        with (instance_create_layer(VIEW_RIGHT - 60, VIEW_CENTRE_Y - amp - 10, layer, obj_enemy)) {
            amplitudeX = amp / 2;
            amplitudeY = amp;
        }
        with (instance_create_layer(VIEW_RIGHT - 60, VIEW_CENTRE_Y + amp + 20, layer, obj_enemy)) {
            amplitudeX = amp / 2;
            amplitudeY = amp;
        }
        break;
    case 2:
        with (instance_create_layer(VIEW_RIGHT - 90, VIEW_CENTRE_Y, layer, obj_enemy)) {
            amplitudeX = 10;
            amplitudeY = 10;
        }
        with (instance_create_layer(VIEW_RIGHT - 50, VIEW_CENTRE_Y - 60, layer, obj_enemy)) {
            amplitudeX = 20;
            amplitudeY = 20;
        }
        with (instance_create_layer(VIEW_RIGHT - 50, VIEW_CENTRE_Y + 60, layer, obj_enemy)) {
            amplitudeX = 20;
            amplitudeY = 20;
        }
        break;
    case 3:
        with (instance_create_layer(VIEW_RIGHT - 90, VIEW_CENTRE_Y, layer, obj_enemy)) {
            amplitudeX = 10;
            amplitudeY = 10;
        }
        with (instance_create_layer(VIEW_RIGHT - 90, VIEW_CENTRE_Y, layer, obj_enemy)) {
            amplitudeX = 50;
            amplitudeY = 50;
        }
    }
}