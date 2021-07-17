/* Shader Effects
 * --------------
 */

/// @desc Clipping effect.
/// @param {Real} x1 The left-most position to clip.
/// @param {Real} y1 The top-most position to clip.
/// @param {Real} x2 The right-most position to clip.
/// @param {Real} y2 The bottom-most position to clip.
function shader_set_effect_clip(_x1, _y1, _x2, _y2) {
	static u_point_a = shader_get_uniform(shd_clipping, "u_pointA");
	static u_point_b = shader_get_uniform(shd_clipping, "u_pointB");
	shader_set(shd_clipping);
	shader_set_uniform_f(u_point_a, _x1, _y1);
	shader_set_uniform_f(u_point_b, _x2, _y2);
}

/// @desc Dithering effect.
/// @param {Real} [intensity=1] The intensity of the dithering.
function shader_set_effect_dithering() {
	static u_intensity = shader_get_uniform(shd_dither, "u_intensity");
	var intensity = argument_count > 0 ? argument[0] : 1;
	shader_set(shd_dither);
	shader_set_uniform_f(u_intensity, intensity);
}

/// @desc Greyscale effect.
/// @param {Real} [ratio=1] The intensity of the greyscale.
function shader_set_effect_greyscale() {
	static u_ratio = shader_get_uniform(shd_greyscale, "u_ratio");
	var ratio = argument_count > 0 ? argument[0] : 1;
	shader_set(shd_greyscale);
	shader_set_uniform_f(u_ratio, ratio);
}

/// @desc Sepia effect.
/// @param {Real} [ratio=1] The intensity of the sepia.
function shader_set_effect_sepia() {
	static u_ratio = shader_get_uniform(shd_sepia, "u_ratio");
	var ratio = argument_count > 0 ? argument[0] : 1;
	shader_set(shd_sepia);
	shader_set_uniform_f(u_ratio, ratio);
}

/// @desc Invert effect.
function shader_set_effect_invert() {
	shader_set(shd_invert);
}

/// @desc Saturation effect.
/// @param {Real} [intensity=1] The intensity of the saturation.
function shader_set_effect_saturate() {
	static u_intensity = shader_get_uniform(shd_saturate, "u_intensity");
	var intensity = argument_count > 0 ? argument[0] : 1;
	shader_set(shd_saturate);
	shader_set_uniform_f(u_intensity, intensity);
}

/// @desc Brightness effect.
/// @param {Real} [ratio=0.5] The intensity of the brightness.
function shader_set_effect_brightness() {
	static u_intensity = shader_get_uniform(shd_brightness, "u_intensity");
	var ratio = argument_count > 0 ? argument[0] : 0.5;
	shader_set(shd_brightness);
	shader_set_uniform_f(u_intensity, ratio * 2 - 1);
}

/// @desc Colour shift effect.
/// @param {Real} [angle=0] The number of degrees to rotate the hue.
function shader_set_effect_hue_shift() {
	static u_shift = shader_get_uniform(shd_hue_shift, "u_shift");
	var angle = argument_count > 0 ? argument[0] : 0;
	shader_set(shd_hue_shift);
	shader_set_uniform_f(u_shift, angle / 360);
}

/// @desc Posterisation effect.
/// @param {Real} n The number of colours to limit.
/// @param {Real} [gamma=0.6] The gamma of the image.
function shader_set_effect_posterise(_n) {
	static u_gamma = shader_get_uniform(shd_posterise, "u_gamma");
	static u_colour_count = shader_get_uniform(shd_posterise, "u_colour_count");
	var gamma = argument_count > 1 ? argument[1] : 0.6;
	shader_set(shd_posterise);
	shader_set_uniform_f(u_gamma, gamma);
	shader_set_uniform_f(u_colour_count, _n);
}

/// @desc Draws this sprite with a pattern masked over it.
/// @param {Real} sprite The sprite to draw.
/// @param {Real} subimg The subimage of the sprite to use.
/// @param {Real} x X position.
/// @param {Real} y Y position.
/// @param {Real} xscale X scale.
/// @param {Real} yscale Y scale.
/// @param {Real} rot Rotation.
/// @param {Real} col Blend.
/// @param {Real} alpha Alpha.
/// @param {Real} pattern The sprite of the pattern of mask.
/// @param {Real} subpattern The subimage of the pattern to mask.
/// @param {Real} xoff The X offset for this pattern.
/// @param {Real} yoff The Y offset for this pattern.
function draw_sprite_pattern(_sprite, _subimg, _x, _y, _xscale, _yscale, _angle, _colour, _alpha, _pattern, _subpattern, _xoff, _yoff) {
	static sampler_texture = shader_get_sampler_index(shd_pattern, "s_samplerTexture");
	static sampler_size = shader_get_uniform(shd_pattern, "u_samplerSize");
	static sampler_uvs = shader_get_uniform(shd_pattern, "u_samplerUVs");
	static sampler_offset = shader_get_uniform(shd_pattern, "u_samplerOffset");
	var last_shader = shader_current();
	shader_set(shd_pattern);
	texture_set_stage(sampler_texture, sprite_get_texture(_pattern, _subpattern));
	shader_set_uniform_f(sampler_size, sprite_get_width(_pattern), sprite_get_height(_pattern));
	shader_set_uniform_f_array(sampler_uvs, sprite_get_uvs(_pattern, _subpattern));
	shader_set_uniform_f(sampler_offset, _xoff, _yoff);
	draw_sprite_ext(_sprite, _subimg, _x, _y,
			_xscale, _yscale, _angle, _colour, _alpha);
	if (last_shader == -1) {
		shader_reset();
	} else {
		shader_set(last_shader);
	}
}