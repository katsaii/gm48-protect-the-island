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
part_system_automatic_draw(partSys, false);
show_debug_overlay(true);