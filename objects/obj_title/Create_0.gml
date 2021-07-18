/// @desc Initialise the title.
optionThreshold = 0.65;
creditThreshold = 0.3;
ini_open("data.ini");
global.highscore = max(ini_read_real("achievements", "score", 0), 0);
global.score = 0;
ini_close();
selection = 0;
selectionSubmit = false;
musicEmitter = audio_emitter_create();
musicFade = 0;
musicFadeCounter = 0.005;
audio_emitter_gain(musicEmitter, 0);
audio_play_sound_on(musicEmitter, bgm_title, true, 100);