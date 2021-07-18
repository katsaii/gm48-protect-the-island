/// @desc Save high score.
audio_emitter_free(selectionEmitter);
audio_emitter_free(musicEmitter);
if (global.score > 0 && global.score > global.highscore) {
    ini_open("data.ini");
    ini_write_real("achievements", "score", global.score);
    ini_close();
}