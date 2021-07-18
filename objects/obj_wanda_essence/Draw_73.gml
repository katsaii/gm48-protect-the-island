/// @desc Draw essence.
gpu_set_blendmode(bm_add);
draw_sprite_ext(sprite_index, image_index, floor(x), floor(y), image_xscale, image_yscale, image_angle, image_blend, 1 - lifeTimer);
gpu_set_blendmode(bm_normal);