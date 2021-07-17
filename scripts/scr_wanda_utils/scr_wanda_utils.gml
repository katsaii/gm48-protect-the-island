/// @desc Draws a witch.
/// @param {real} witch_sprite The sprite index of the witch to draw.
/// @param {real} witch_image The image index of the witch to draw.
/// @param {real} broom_sprite The sprite index of the broom to draw.
/// @param {real} broom_image The image index of the broom to draw.
/// @param {real} x The x position to draw the witch at.
/// @param {real} y The y position to draw the witch at.
/// @param {real} xscale The x scale of the witch.
/// @param {real} yscale The y scale of the witch.
/// @param {real} colour The colour of the witch.
/// @param {real} alpha The transparency of the witch.
/// @param {real} [dx] The x speed of the witch.
/// @param {real} [dy] The y speed of the witch.
function draw_witch(_witch_spr, _witch_img, _broom_spr, _broom_img, _x, _y, _xscale, _yscale, _colour, _alpha, _dx=0, _dy=0) {
    var angle = 5 * -(_dx + _dy);
    draw_sprite_ext(_broom_spr, _broom_img, _x, _y, _xscale, _yscale, angle, _colour, _alpha);
    draw_sprite_ext(_witch_spr, _witch_img, _x, _y, _xscale, _yscale, 0.5 * -angle, _colour, _alpha);
}

/// @desc Computes the direction from two key presses.
/// @param {real} key_min The key to check to decelerate.
/// @param {real} key_max The key to check to accelerate.
function keyboard_direction(_key_min, _key_max) {
    return keyboard_check(_key_max) - keyboard_check(_key_min);
}

/// @desc Updates a movement scalar.
/// @param {real} prev_x The current speed.
/// @param {real} acc The acceleration.
/// @param {real} frict The friction coefficient.
/// @param {real} handling The handling coefficient.
/// @param {real} dir The direction of movement.
function movement_iterate(_prev_x, _acc, _frict, _handling, _dir) {
    var new_x;
    if (_dir == 0) {
        var prev_sign = sign(_prev_x);
        new_x = _prev_x - prev_sign * _acc * 0.5;
        if (prev_sign != sign(new_x)) {
            new_x = 0;
        }
    } else {
        var dx = _acc * _dir * (sign(_prev_x) != _dir ? _handling : 1);
        var valid_movement = 1 - abs(2 * arctan(_frict * _prev_x) / pi);
        new_x = _prev_x + dx * valid_movement;
    }
    return new_x;
}

/// @desc Spawns a particle at the current position.
/// @param {real} sys The ID of the particle system to use.
function wanda_spawn_particles(_sys) {
    static ty = (function() {
        var _ = part_type_create();
        part_type_shape(_, pt_shape_disk);
        part_type_life(_, 15, 60);
        part_type_direction(_, 0, 360, 0, 5.08);
        part_type_speed(_, 0, 0.2, 0.02, 0.05);
        part_type_size(_, 0.01, 0.05, 0.002, 0.005);
        part_type_alpha3(_, 1, 1, 0);
        part_type_colour3(_, CYellow.REKINDLED, CPink.WILD_STRAWBERRY, CRed.FORREST_FIRE);
        part_type_gravity(_, 0.1, 180);
        return _;
    })();
    part_particles_create(_sys, x, y, ty, 1);
}

#macro SKYLINE_TOP make_colour_rgb(221, 166, 172) // make_colour_rgb(105, 70, 77);
#macro SKYLINE_BOTTOM make_colour_rgb(133, 141, 177) // make_colour_rgb(221, 166, 172);

/// @desc Spawns a skyline particle at the current position.
/// @param {real} sys The ID of the particle system to use.
/// @param {real} x1 The left position of the region to spawn particles in.
/// @param {real} y1 The top position of the region to spawn particles in.
/// @param {real} x2 The right position of the region to spawn particles in.
/// @param {real} y2 The bottom position of the region to spawn particles in.
function wanda_sealine_spawn_particles(_sys, _left, _top, _right, _bottom) {
    static ty = (function() {
        var _ = part_type_create();
        part_type_sprite(_, spr_wave, false, false, true);
        part_type_life(_, 60, 60 * 4);
        part_type_direction(_, 180, 180, 0, 0);
        part_type_speed(_, 0.1, 0.2, 0, 0.00);
        part_type_scale(_, 1, 0.1);
        part_type_alpha3(_, 0, 1, 0);
        //part_type_colour1(_, SKYLINE_TOP);
        part_type_blend(_, true);
        return _;
    })();
    part_particles_create(_sys, random_range(_left, _right), random_range(_top, _bottom), ty, 1);
}

/// @desc Spawns a skyline cloud at the current position.
/// @param {real} sys The ID of the particle system to use.
/// @param {real} x1 The left position of the region to spawn particles in.
/// @param {real} y1 The top position of the region to spawn particles in.
/// @param {real} x2 The right position of the region to spawn particles in.
/// @param {real} y2 The bottom position of the region to spawn particles in.
function wanda_skyline_spawn_particles(_sys, _left, _top, _right, _bottom) {
    static ty = (function() {
        var _ = part_type_create();
        part_type_sprite(_, spr_cloud, false, false, true);
        part_type_life(_, 60 * 6, 60 * 8);
        part_type_direction(_, 180, 180, 0, 0);
        part_type_speed(_, 0.2, 0.6, 0, 0.00);
        part_type_alpha3(_, 0, 0.5, 0);
        //part_type_blend(_, true);
        return _;
    })();
    part_particles_create(_sys, random_range(_left, _right), random_range(_top, _bottom), ty, 1);
}