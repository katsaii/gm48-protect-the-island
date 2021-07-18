/// @desc Initialise this enemy.
witch = asset_get_index("spr_witch_" + string_lower(chr(irandom_range(ord("A"), ord("H")))));
bulletId = irandom_range(1, 3);
bullet = asset_get_index("spr_bullet_" + string(bulletId));
hp = choose(3, 3, 3, 5, 5, 7);
blastTimer = choose(0, 0.25, 0.5, 0.75);
blastCounter = 0.01;
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