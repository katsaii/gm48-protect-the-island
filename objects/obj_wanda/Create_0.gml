/// @desc Initialise Wanda.
xspeed = 0;
yspeed = 0;
acc = 0.3;
handling = 5;
frict = 1.5;
partSys = part_system_create_layer(layer, true);
blast = false;
blastTimer = -1;
blastCountdown = 0.3;
hitTimer = 0;
hitCounter = 0.025;
flyEmitter = audio_emitter_create();
shootEmitter = audio_emitter_create();
hurtEmitter = audio_emitter_create();
audio_emitter_gain(flyEmitter, 0);
audio_play_sound_on(flyEmitter, snd_wanda_fly, true, 100);
part_system_automatic_draw(partSys, false);
//show_debug_overlay(true);