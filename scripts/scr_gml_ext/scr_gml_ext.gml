/* GML Extension Functions
 * -----------------------
 */

/// @desc Resizes the window and centres it. Undefined behaviour if width or height is smaller/larger than min/max width or height.
/// @param {real} width The width to resize to.
/// @param {real} height The height to resize to.
function window_set_size_centre(_width, _height) {
	window_set_rectangle(
			(display_get_width() - _width) div 2,
			(display_get_height() - _height) div 2,
			_width, _height);
}

/// @desc Centres the camera to this position.
/// @param {real} cam The id of the camera to update.
/// @param {real} x The x position of the display.
/// @param {real} y The y position of the display.
function camera_set_view_pos_centre(_cam, _x, _y) {
	camera_set_view_pos(_cam,
			_x - camera_get_view_width(_cam) div 2,
			_y - camera_get_view_height(_cam) div 2);
}

/// @desc Performs 2-chain IK.
/// @param {real} anx The x position of the anchor.
/// @param {real} any The y position of the anchor.
/// @param {real} effx The x position of the end effector.
/// @param {real} effy The y position of the end effector.
/// @param {real} a The length of the first arm.
/// @param {real} b The length of the second arm.
/// @param {real} bend The direction to bend the leg.
function ik_chain(_anx, _any, _effx, _effy, _a, _b, _bend) {
	var tx = _effx - _anx;
	var ty = _effy - _any;
	var dd = tx * tx + ty * ty;
	var dir = -darctan2(ty, tx);
	var rotb = darccos(clamp((dd - _a * _a - _b * _b) / max(2 * _a * _b, 0.0000001), -1, 1)) * _bend;
	var rota = dir - darctan2(_b * dsin(rotb), _a + _b * dcos(rotb));
	return [rota, rotb];
}

/// @desc Finds the intersection point of an object.
function collision_line_point(_x1, _y1, _x2, _y2, _obj, _prec, _notme) {
	var rr, rx, ry;
	rr = collision_line(_x1, _y1, _x2, _y2, _obj, _prec, _notme);
	rx = _x2;
	ry = _y2;
	if (rr != noone) {
		var p0 = 0;
		var p1 = 1;
		repeat (ceil(log2(point_distance(_x1, _y1, _x2, _y2))) + 1) {
			var np = p0 + (p1 - p0) * 0.5;
			var nx = _x1 + (_x2 - _x1) * np;
			var ny = _y1 + (_y2 - _y1) * np;
			var px = _x1 + (_x2 - _x1) * p0;
			var py = _y1 + (_y2 - _y1) * p0;
			var nr = collision_line(px, py, nx, ny, _obj, _prec, _notme);
			if (nr != noone) {
				rr = nr;
				rx = nx;
				ry = ny;
				p1 = np;
			} else p0 = np;
		}
	}
	var r;
	r[0] = rr;
	r[1] = rx;
	r[2] = ry;
	return r;
}

/// @desc Returns the maximum height of a font.
/// @param {real} font The font to check.
function font_get_height(_font) {
	var current = draw_get_font();
	draw_set_font(_font);
	var height = string_height("AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789");
	draw_set_font(current);
	return height;
}

/// @desc Draws text with a background. Only supports text being top-left aligned.
/// @param {real} x The x position to render the text.
/// @param {real} y The y position to render the text.
/// @param {value} string The text to draw.
function draw_text_background(_x, _y, _value) {
	var text_colour = draw_get_colour();
	var text_alpha = draw_get_alpha();
	var bg_colour = 0xffffff - text_colour;
	var bg_alpha = text_alpha * 0.4;
	var str = is_string(_value) ? _value : string(_value);
	var width = string_width(str);
	var height = string_height(str);
	var bg_left, bg_right, text_x;
	switch (draw_get_halign()) {
	case fa_left:
		bg_left = _x;
		bg_right = bg_left + width;
		text_x = bg_left;
		break;
	case fa_right:
		bg_right = _x;
		bg_left = bg_right - width;
		text_x = bg_right;
		break;
	//case fa_center:
	default:
		bg_left = _x - 0.5 * width;
		bg_right = _x + 0.5 * width;
		text_x = _x;
		break;
	}
	var bg_top, bg_bottom, text_y;
	switch (draw_get_valign()) {
	case fa_top:
		bg_top = _y;
		bg_bottom = bg_top + height;
		text_y = bg_top;
		break;
	case fa_bottom:
		bg_bottom = _y;
		bg_top = bg_bottom - height;
		text_y = bg_bottom;
		break;
	//case fa_center:
	default:
		bg_top = _y - 0.5 * height;
		bg_bottom = _y + 0.5 * height;
		text_y = _y;
		break;
	}
	draw_set_colour(bg_colour);
	draw_set_alpha(bg_alpha);
	draw_rectangle(
			floor(bg_left) - 1, floor(bg_top),
			floor(bg_right) - 1, floor(bg_bottom) - 1, false);
	draw_set_colour(text_colour);
	draw_set_alpha(text_alpha);
	draw_text(floor(text_x), floor(text_y), str);
}

/// @desc Returns a given string, word wrapped to a pixel width.
/// @param str {String} The text to word wrap.
/// @param width {Integer} The maximum pixel width before a line break.
function string_wrap(_str, _width) {
	// GMLscripts.com/license
	var pos_space = -1;
	var pos_current = 1;
	var text_current = _str;
	var text_output = "";
	while (string_length(text_current) >= pos_current) {
		if (string_width(string_copy(text_current,1,pos_current)) > _width) {
			if (pos_space != -1) {
				text_output += string_copy(text_current, 1, pos_space) + "\n";
				text_current = string_copy(text_current, pos_space + 1, string_length(text_current) - pos_space);
			} else {
				text_output += string_copy(text_current, 1, pos_current - 1) + "\n";
				text_current = string_copy(text_current, pos_current, string_length(text_current) - (pos_current - 1));
			}
			pos_current = 1;
			pos_space = -1;
		}
		if (string_char_at(text_current,pos_current) == " ") {
			pos_space = pos_current;
		}
		pos_current += 1;
	}
	if (string_length(text_current) > 0) {
		text_output += text_current;
	}
	return text_output;
}

/// @desc Returns whether a string is a whitespace character.
/// @param str {String} The string to check.
function string_is_whitespace(_str) {
	for (var i = string_length(_str); i > 0; i -= 1) {
		switch (string_char_at(_str, i)) {
		case " ":
		case "\n":
		case "\r":
		case "\t":
			return true;
		}
	}
	return false;
}

/// @desc Returns a color merged from a series of two or more colors by a given amount.
/// @param {real} amount The blend factor.
/// @param {real} col1 The first colour.
/// @param {real} col2 The second colour.
function merge_colour_ext(_amount) {
	// GMLscripts.com/license
	var seg = _amount * (argument_count - 2);
	var colour_id = floor(seg);
	return merge_colour(argument[colour_id], argument[colour_id + 1], seg - colour_id);
}

/// @desc Returns `true` given a chance out of 100%.
/// @param {real} percent The percentage chance to return `true`.
function random_chance(_percent) {
	return _percent != 0 && _percent >= random(1);
}

/// @desc Returns the course direction required to hit a moving target at a given projectile speed, or undefined if no solution is found.
/// @param {real} ox The x-position to launch from.
/// @param {real} oy The y-position to launch from.
/// @param {real} ospeed The speed to launch with.
/// @param {real} tx The x-position to launch to.
/// @param {real} ty The y-position to launch to.
/// @param {real} tspeed The speed the target is moving at.
/// @param {real} tangle The angle the target is moving with.
function projectile_intercept(_ox, _oy, _ospeed, _tx, _ty, _tspeed, _tangle) {
	// GMLscripts.com/license
	var oangle = point_direction(_ox, _oy, _tx, _ty);
	var theta = _tspeed / _ospeed * dsin(_tangle - oangle);
	return theta * theta >= 1 ? undefined : oangle + darcsin(theta);
}

/// @desc Moves `a` towards `b` by some `speed`.
/// @param {real} a The source angle.
/// @param {real} b The destination angle.
/// @param {real} speed The amount, in degrees, to move.
function angle_approach(_source, _dest, _speed) {
	var dx = -angle_difference(_source, _dest);
	var du = sign(dx);
	return _source + min(_speed, dx * du) * du;
}

/// @desc Smoothly moves `a` towards `b` by some `amount`.
/// @param {real} a The source angle.
/// @param {real} b The destination angle.
/// @param {real} amount The amount, as a coefficient, to move.
function angle_approach_smooth(_source, _dest, _amount) {
	var dx = -angle_difference(_source, _dest);
	return abs(dx) < 0.01 ? _dest : _source + dx * _amount;
}

/// @desc Truncates an angle in the range `0..360` to values in the range `0..n`.
/// @param {real} angle The angle to snap.
/// @param {real} n The range to snap to.
function angle_snap(_angle, _n) {
	var sep = 360 / _n;
	return floor(_angle / sep + 0.5) * sep;
}

/// @desc Moves `a` towards `b` by some `speed`.
/// @param {real} a The source value.
/// @param {real} b The destination value.
/// @param {real} speed The speed to move.
function approach(_source, _target, _speed) {
	var dx = abs(_speed);
	return _source < _target ? min(_target, _source + dx) : max(_target, _source - dx);
}

/// @desc Smoothly moves `a` towards `b` by some `speed`.
/// @param {real} a The source value.
/// @param {real} b The destination value.
/// @param {real} amount The speed to move.
function approach_smooth(_source, _target, _amount) {
	var dx = _target - _source;
	return abs(dx) < 0.01 ? _target : _source + dx * _amount;
}

/// @desc Calculates a triangle wave.
/// @param {real} radians The angle in radians.
function tri(_radians) {
	var theta = _radians / 2 / pi - 0.25;
	return 1 - 4 * abs(round(theta) - theta);
}

/// @desc Calculates a triangle wave, in degrees.
/// @param {real} degrees The angle in degrees.
function dtri(_degrees) {
	return tri(_degrees * pi / 360);
}

/// @desc Similar to terniary operator, except both sides of the decision are evaluated, and a value is returned depending on the condition.
/// @param {bool} condition The condition to check.
/// @param {value} a The value to return if `condition` is truthy.
/// @param {value} b The value to return if `condition` is falsy.
function iif(_condition, _if_true, _if_false) {
	return _condition ? _if_true : _if_false;
}

/// @desc Maps a number from one range to another.
/// @param {real} value The value to map.
/// @param {real} min1 The minimum bound of the source range.
/// @param {real} max1 The maximum bound of the source range.
/// @param {real} min2 The minimum bound of the destination range.
/// @param {real} max2 The maximum bound of the destination range.
function map_range(_value, _min1, _max1, _min2, _max2) {
	var dx = _max1 - _min1;
	var dy = _max2 - _min2;
	return dx == 0 ? NaN : (_value - _min1) / dx * dy + _min2;
}

/// @desc Returns a smooth transition from 0 to 1.
/// @param {real} x The position of the smoothstep function, in the range `0..1`.
function smoothstep(_x) {
	// GMLscripts.com/license
	var amount = clamp(argument0,0,1);
	return amount * amount * (3 - 2 * amount);
}

/// @desc Returns a smooth transition from 0 to 1 by calling the smoothstep function multiple times.
/// @param {real} x The position of the smoothstep function, in the range `0..1`.
/// @param {real} n The number of times to embed smoothstep.
function smoothstepf(_x, _n) {
	var fractal = _x;
	repeat (_n) {
		fractal = smoothstep(fractal);
	}
	return fractal;
}

/// @desc Draws a bezier curve with 3 control points.
/// @param x1 {Real} The X coordinate of the first control point.
/// @param y1 {Real} The Y coordinate of the first control point.
/// @param x2 {Real} The X coordinate of the second control point.
/// @param y2 {Real} The Y coordinate of the second control point.
/// @param x3 {Real} The X coordinate of the third control point.
/// @param y3 {Real} The Y coordinate of the third control point.
/// @param x1 {Real} The X coordinate of the first control point.
/// @author Kat @katsaii
function draw_bezier(_x1, _y1, _x2, _y2, _x3, _y3) {
	var step = 0.1;
	draw_primitive_begin(pr_linestrip);
	draw_vertex(_x1, _y1);
	for (var i = 0; i <= 1; i += step) {
		// get intermediate coordinates
		var ix = lerp(_x1, _x2, i);
		var iy = lerp(_y1, _y2, i);
		var jx = lerp(_x2, _x3, i);
		var jy = lerp(_y2, _y3, i);
		// get final curve point
		var bx = lerp(ix, jx, i);
		var by = lerp(iy, jy, i);
		draw_vertex(bx, by);
	}
	draw_vertex(_x3, _y3);
	draw_primitive_end();
}

/// @desc Draws a bezier curve with 4 control points.
/// @param x1 {Real} The X coordinate of the first control point.
/// @param y1 {Real} The Y coordinate of the first control point.
/// @param x2 {Real} The X coordinate of the second control point.
/// @param y2 {Real} The Y coordinate of the second control point.
/// @param x3 {Real} The X coordinate of the third control point.
/// @param y3 {Real} The Y coordinate of the third control point.
/// @param x4 {Real} The X coordinate of the fourth control point.
/// @param y4 {Real} The Y coordinate of the fourth control point.
/// @author Kat @katsaii
function draw_bezier4(_x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4) {
	var step = 0.1;
	draw_primitive_begin(pr_linestrip);
	draw_vertex(_x1, _y1);
	for (var i = 0; i <= 1; i += step) {
		// get intermediate coordinates
		var ix = lerp(_x1, _x2, i);
		var iy = lerp(_y1, _y2, i);
		var jx = lerp(_x2, _x3, i);
		var jy = lerp(_y2, _y3, i);
		var kx = lerp(_x3, _x4, i);
		var ky = lerp(_y3, _y4, i);
		//draw_line_colour(ix, iy, jx, jy, c_red, c_red);
		//draw_line_colour(jx, jy, kx, ky, c_red, c_red);
		// get further intermediate coordinates
		var iix = lerp(ix, jx, i);
		var iiy = lerp(iy, jy, i);
		var jjx = lerp(jx, kx, i);
		var jjy = lerp(jy, ky, i);
		//draw_line_colour(iix, iiy, jjx, jjy, c_blue, c_blue);
		// get final curve point
		var bx = lerp(iix, jjx, i);
		var by = lerp(iiy, jjy, i);
		draw_vertex(bx, by);
		//draw_circle_colour(bx, by, 4, c_purple, c_purple, true);
	}
	draw_vertex(_x4, _y4);
	draw_primitive_end();
	draw_line_colour(_x1, _y1, _x2, _y2, c_red, c_red);
	draw_line_colour(_x2, _y2, _x3, _y3, c_red, c_red);
	draw_line_colour(_x3, _y3, _x4, _y4, c_red, c_red);
}

/// @desc Clones an array.
/// @param {array} variable The array to clone.
function array_clone(_array) {
	if (array_length(_array) < 1) {
		return [];
	} else {
		_array[0] = _array[0];
		return _array;
	}
}

/// @desc Returns whether an array is empty.
/// @param {array} variable The array to check.
function array_empty(_array) {
	return array_length(_array) < 1;
}

/// @desc Returns the index of an element in an array. Returns `-1` if the value does not exist.
/// @param {array} variable The array to search.
/// @param {value} value The value to search for.
/// @param {int} [n] The number of elements to loop through.
/// @param {int} [i=0] The index of the array to start at.
function array_find_index(_array, _value) {
	var count = argument_count > 2 ? argument[2] : array_length(_array);
	var start = argument_count > 3 ? argument[3] : 0;
	for (var i = count - 1; i >= 0; i -= 1) {
		if (_value == _array[start + i]) {
			return start + i;
		}
	}
	return -1;
}

/// @desc Applies a function to all elements of an array and returns a new array.
/// @param {array} variable The array to apply the function to.
/// @param {script} f The function to apply to all elements in the array.
/// @param {int} [n] The size of the output array.
/// @param {int} [i=0] The index of the array to start at.
function array_map(_array, _f) {
	var count = argument_count > 2 ? argument[2] : array_length(_array);
	var start = argument_count > 3 ? argument[3] : 0;
	var clone = array_create(count);
	for (var i = 0; i < count; i += 1) {
		clone[@ i] = _f(_array[start + i]);
	}
	return clone;
}

/// @desc Calls some procedure for each element of an array.
/// @param {array} variable The array to apply the function to.
/// @param {script} f The function to apply to all elements in the array.
/// @param {int} [n] The number of elements to loop through.
/// @param {int} [i=0] The index of the array to start at.
function array_foreach(_array, _f) {
	var count = argument_count > 2 ? argument[2] : array_length(_array);
	var start = argument_count > 3 ? argument[3] : 0;
	for (var i = 0; i < count; i += 1) {
		_f(_array[start + i]);
	}
}

/// @desc Checks whether an array contains a value.
/// @param {array} variable The array to consider.
/// @param {value} value The value to compare.
/// @param {int} [n] The number of elements to loop through.
/// @param {int} [i=0] The index of the array to start at.
function array_contains(_array, _target) {
	var count = argument_count > 2 ? argument[2] : array_length(_array);
	var start = argument_count > 3 ? argument[3] : 0;
	var compare_arrays = is_array(_target);
	for (var i = count - 1; i >= 0; i -= 1) {
		var val = _array[start + i];
		if (compare_arrays && is_array(val) &&
				array_equals(val, _target) ||
				val == _target) {
			return true;
		} 
	}
	return false;
}

/// @desc Applies a left-associative operation to all elements of this array in sequence.
/// @param {array} variable The array to consider.
/// @param {value} y0 The default value.
/// @param {script} f The function to apply.
/// @param {int} [n] The number of elements to loop through.
/// @param {int} [i=0] The index of the array to start at.
function array_foldl(_array, _y0, _f) {
	var count = argument_count > 3 ? argument[3] : array_length(_array);
	var start = argument_count > 4 ? argument[4] : 0;
	var acc = _y0;
	for (var i = 0; i < count; i += 1) {
		acc = _f(acc, _array[start + i]);
	}
	return acc;
}

/// @desc Applies a right-associative operation to all elements of this array in sequence.
/// @param {array} variable The array to consider.
/// @param {value} y0 The default value.
/// @param {script} f The function to apply.
/// @param {int} [n] The number of elements to loop through.
/// @param {int} [i=0] The index of the array to start at.
function array_foldr(_array, _y0, _f) {
	var count = argument_count > 3 ? argument[3] : array_length(_array);
	var start = argument_count > 4 ? argument[4] : 0;
	var acc = _y0;
	for (var i = count - 1; i >= 0; i -= 1) {
		acc = _f(_array[start + i], acc);
	}
	return acc;
}

/// @desc Clones a struct.
/// @param {struct} struct The struct to clone.
function struct_clone(_struct) {
	if (instanceof(_struct) != "struct") {
		throw "structs created using constructor functions are not supported";
	}
	var clone = { };
	var count = variable_struct_names_count(_struct);
	var names = variable_struct_get_names(_struct);
	for (var i = count - 1; i >= 0; i -= 1) {
		var key = names[i];
		var val = variable_struct_get(_struct, key);
		if (is_method(val) && method_get_self(val) == _struct) {
			throw "cannot clone structs which contain methods bound to self";
		}
		variable_struct_set(clone, key, val);
	}
	return clone;
}

/// @desc Calls some procedure for each key-value pairs of a struct.
/// @param {struct} struct The struct to apply the function to.
/// @param {script} f The function to apply.
function struct_foreach(_struct, _f) {
	var count = variable_struct_names_count(_struct);
	var names = variable_struct_get_names(_struct);
	for (var i = count - 1; i >= 0; i -= 1) {
		var key = names[i];
		var val = variable_struct_get(_struct, key);
		_f(key, val);
	}
}

/// @desc Calls some procedure for each member name of a struct.
/// @param {struct} struct The struct to apply the function to.
/// @param {script} f The function to apply.
function struct_foreach_key(_struct, _f) {
	struct_foreach(_struct, method({
		f : _f
	}, function(_key, _) {
		f(_key);
	}));
}

/// @desc Calls some procedure for each member value of a struct.
/// @param {struct} struct The struct to apply the function to.
/// @param {script} f The function to apply.
function struct_foreach_value(_struct, _f) {
	struct_foreach(_struct, method({
		f : _f
	}, function(_, _value) {
		f(_value);
	}));
}