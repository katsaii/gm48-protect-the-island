/// @desc Initialise this enemy.
witch = choose(spr_enemy_test);
hp = 5;
blast = false;
xspeed = 0;
yspeed = 0;
targetX = xstart;
targetY = ystart;
amplitudeX = 10;
amplitudeY = 100;
entryTimer = 0;
entryCounter = 0.01;
hitTimer = 0;
hitCounter = 0.05;
angle = 0;
angleSpeed = 2;
hurtEmitter = audio_emitter_create();
partSys = part_system_create_layer(layer, true);
part_system_automatic_draw(partSys, false);