varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 pixel_col = v_vColour*texture2D(gm_BaseTexture,v_vTexcoord);
	// invert channels
	pixel_col.rgb = 1.0-pixel_col.rgb;
    gl_FragColor = pixel_col;
}