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
        part_type_alpha3(_, 0, 0.3, 0);
        part_type_blend(_, true);
        return _;
    })();
    part_particles_create(_sys, random_range(_left, _right), random_range(_top, _bottom), ty, 1);
}

/// @desc Spawns a skyline island.
/// @param {real} sys The ID of the particle system to use.
/// @param {real} x1 The left position of the region to spawn particles in.
/// @param {real} y1 The top position of the region to spawn particles in.
/// @param {real} x2 The right position of the region to spawn particles in.
/// @param {real} y2 The bottom position of the region to spawn particles in.
function wanda_island_spawn_particles(_sys, _left, _top, _right, _bottom) {
    static ty = (function() {
        var _ = part_type_create();
        var life = 60 * 20;
        part_type_sprite(_, spr_island_floating, false, false, true);
        part_type_life(_, life, life);
        part_type_direction(_, 180, 180, 0, 0);
        part_type_speed(_, 0.4, 0.9, 0, 0.00);
        return _;
    })();
    part_particles_create(_sys, random_range(_left, _right), random_range(_top, _bottom), ty, 1);
}

/// @desc Draws text in a 3d stylised way.
/// @param {real} x The x position to draw the text at.
/// @param {real} y The y position to draw the text at.
/// @param {real} text The text to draw.
/// @param {real} amount The amount of 3d layers to apply.
/// @param {real} outline The outline colour of the text.
/// @param {real} fill The fill of the text.
function draw_text_3d(_x, _y, _text, _layer_count, _outline, _fill) {
    static sep = 1;
    var angle = 0;
    var dx = lengthdir_x(sep, angle);
    var dy = lengthdir_y(sep, angle);
    for (var i = 0; i < _layer_count; i += 1) {
        var col = merge_color(_outline, _fill, i / _layer_count)
        draw_text_color(_x + i * dx, _y + i * dy, _text, col, col, col, col, 1);
    }
}

/// @desc Draws text in a stylised way.
/// @param {real} x The x position to draw the text at.
/// @param {real} y The y position to draw the text at.
/// @param {real} text The text to draw.
function draw_text_wonky(_x, _y, _text) {
    var angle = 2 * dsin(-_y * 3 + current_time * 0.05);
    draw_text_transformed(_x, _y, _text, 1, 1, angle);
}

/// @desc Applies ease-in interpolation.
/// @param {real} amount The amount to interpolate.
function easein(_interp) {
    static chan = animcurve_get_channel(ac_easein, 0);
    return animcurve_channel_evaluate(chan, _interp);
}

#macro VIEW_LEFT camera_get_view_x(VIEW_CAM)
#macro VIEW_TOP camera_get_view_y(VIEW_CAM)
#macro VIEW_WIDTH camera_get_view_width(VIEW_CAM)
#macro VIEW_HEIGHT camera_get_view_height(VIEW_CAM)
#macro VIEW_RIGHT (VIEW_LEFT + VIEW_WIDTH)
#macro VIEW_BOTTOM (VIEW_TOP + VIEW_HEIGHT)
#macro VIEW_CENTRE_X (VIEW_LEFT + VIEW_WIDTH / 2)
#macro VIEW_CENTRE_Y (VIEW_TOP + VIEW_HEIGHT / 2)

#macro COLOUR_BLEND merge_colour(CPurple.MARDI_GRAS, CYellow.REKINDLED, (1 + dsin(current_time * 0.1)) / 8)