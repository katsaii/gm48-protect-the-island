/// @desc Initialise the title.
optionThreshold = 0.65;
creditThreshold = 0.3;
ini_open("data.ini");
global.highscore = max(ini_read_real("achievements", "score", 0), 0);
global.score = 0;
ini_close();
selection = 0;
selectionSubmit = false;