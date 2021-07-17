varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_intensity;

void main()
{
	vec4 pixel_col = v_vColour*texture2D(gm_BaseTexture,v_vTexcoord);
	// add brightness to pixels
	pixel_col.r += u_intensity;
	pixel_col.g += u_intensity;
	pixel_col.b += u_intensity;
    gl_FragColor = pixel_col;
}