/// @desc Initialise the gameloop.
obj_title.visible = false;
global.hp = 15;
hpDrain = 0.03;
fadeIn = 0;
fadeInCounter = 0.01;
fadeOut = 0;
fadeOutCounter = 0.01;
gameRestart = false;
gameRestartTimer = 1;
gameRestartCounter = 0.01;
gameOver = false;
gameOverEmitter = audio_emitter_create();
musicEmitter = audio_emitter_create();
musicFade = -0.25;
musicFadeCounter = 0.005;
audio_emitter_gain(gameOverEmitter, 0);
audio_emitter_gain(musicEmitter, 0);
//audio_play_sound_on(musicEmitter, bgm_gameplay, true, 100);