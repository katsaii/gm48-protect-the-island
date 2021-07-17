/// @desc Save high score.
if (global.score > 0 && global.score > global.highscore) {
    ini_open("data.ini");
    ini_write_real("achievements", "score", global.score);
    ini_close();
}