/// @desc Draw GUI.
draw_set_font(fnt_tiny);
draw_set_color(COLOUR_BLEND);
draw_set_valign(fa_top);
draw_set_halign(fa_center);
draw_text_wonky(VIEW_CENTRE_X, VIEW_TOP + 10, "Score: " + string(global.score) + " (High: " + string(global.highscore) + ")");