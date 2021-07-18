/// @desc Initialise this enemy.
witch = asset_get_index("spr_witch_" + string_lower(chr(irandom_range(ord("A"), ord("H")))));
var bullet_id = irandom_range(1, 3);
bullet = asset_get_index("spr_bullet_" + string(bullet_id));
hp = choose(3, 5, 7);
blastTimer = 0;
var counters = [1, 2, 3];
blastCounter = 0.01 * counters[bullet_id - 1];
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