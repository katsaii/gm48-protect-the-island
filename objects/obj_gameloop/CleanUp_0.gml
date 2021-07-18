/// @desc Make the title visible again.
instance_destroy(obj_wanda_projectile);
audio_emitter_free(musicEmitter);
obj_title.visible = true;
if (global.highscore < global.score) {
    global.highscore = global.score;
}