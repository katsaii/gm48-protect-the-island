/// @desc Update enemy position.
entryTimer += entryCounter;
if (entryTimer > 1) {
    entryTimer = 1;
}
var interp = easein(entryTimer);
angle += angleSpeed;
var path_x = targetX + lengthdir_x(amplitudeX, angle);
var path_y = targetY + lengthdir_y(amplitudeY, angle);
x = lerp(VIEW_RIGHT + 50, path_x, interp);
y = lerp(targetY, path_y, interp);
xspeed = x - xprevious;
yspeed = y - yprevious;