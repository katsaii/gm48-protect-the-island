/// @desc Draw message.
draw_set_font(fnt_default);
draw_set_colour(CRed.FORREST_FIRE);
draw_set_alpha(1 - lifeTimer);
draw_text_wonky(x, y, "REVENGE");
draw_set_alpha(1);