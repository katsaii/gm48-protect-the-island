/// @desc Initialise this enemy.
witch = choose(spr_enemy_test);
blast = false;
xspeed = 0;
yspeed = 0;
targetX = xstart;
targetY = ystart;
amplitudeX = 10;
amplitudeY = 100;
entryTimer = 0;
entryCounter = 0.01;
angle = 0;
angleSpeed = 2;
partSys = part_system_create_layer(layer, true);
part_system_automatic_draw(partSys, false);