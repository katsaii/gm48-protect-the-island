/// @desc Initialise this enemy.
witch = asset_get_index("spr_enemy_" + choose("a", "b"));
hp = choose(3, 5, 7);
blast = false;
xspeed = 0;
yspeed = 0;
targetX = xstart;
targetY = ystart;
x += 1000; // get them out of the view pls
amplitudeX = 0;
amplitudeY = 0;
entryTimer = 0;
entryCounter = 0.01;
hitTimer = 0;
hitCounter = 0.05;
angle = 0;
angleSpeed = choose(-1, 1) * choose(1, 2, 3);
hurtEmitter = audio_emitter_create();
partSys = part_system_create_layer(layer, true);
part_system_automatic_draw(partSys, false);