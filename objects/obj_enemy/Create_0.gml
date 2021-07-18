/// @desc Initialise this enemy.
var witch_min = ord("A");
var witch_max = ord("H");
while (true) {
    witch = asset_get_index("spr_witch_" + string_lower(chr(irandom_range(witch_min, witch_max))));
    if (instance_number(object_index) - 1 > witch_max - witch_min) {
        break;
    }
    var new_witch = true;
    with (object_index) {
        if (id != other.id && witch == other.witch) {
            new_witch = false;
        }
    }
    if (new_witch) {
        break;
    }
}
bulletId = irandom_range(1, 3);
bullet = asset_get_index("spr_bullet_" + string(bulletId));
hp = choose(1, 2, 3, 3, 3, 3, 5, 5, 5, 5, 7);
blastTimer = choose(0, 0.25, 0.5, 0.75);
blastCounter = 0.02;
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
angleSpeed = choose(-1, 1) * choose(1, 1.5, 2);
hurtEmitter = audio_emitter_create();
partSys = part_system_create_layer(layer, true);
part_system_automatic_draw(partSys, false);