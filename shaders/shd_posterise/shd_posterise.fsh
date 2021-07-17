varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_gamma; // 0.6
uniform float u_colour_count; // 8.0

void main()
{
	// Credit: Xygthop3
	vec4 pixel_col = v_vColour*texture2D( gm_BaseTexture, v_vTexcoord );
	pixel_col.rgb = pow(abs(floor(pow(abs(pixel_col.rgb),vec3(u_gamma))*u_colour_count)/u_colour_count),vec3(1.0/u_gamma));
    gl_FragColor = pixel_col;
}
