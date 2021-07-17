/// @desc Initialise the title.
optionThreshold = 0.7;
ini_open("data.ini");
global.highscore = ini_read_real("achievements", "score", 0);
ini_close();
selection = 0;