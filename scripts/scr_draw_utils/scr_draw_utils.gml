/// @desc Draws a witch.
/// @param {real} witch_sprite The sprite index of the witch to draw.
/// @param {real} witch_image The image index of the witch to draw.
/// @param {real} broom_sprite The sprite index of the broom to draw.
/// @param {real} broom_image The image index of the broom to draw.
/// @param {real} x The x position to draw the witch at.
/// @param {real} y The y position to draw the witch at.
function draw_witch(_witch_spr, _witch_img, _broom_spr, _broom_img, _x, _y) {
    draw_sprite(_broom_spr, _broom_img, _x, _y);
    draw_sprite(_witch_spr, _witch_img, _x, _y);
}