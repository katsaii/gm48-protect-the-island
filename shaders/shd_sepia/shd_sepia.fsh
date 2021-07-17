varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_ratio;

void main()
{
	// Credit: Xygthop3
	vec4 pixel_col = v_vColour*texture2D( gm_BaseTexture, v_vTexcoord );
	vec3 sepia = vec3(0.0);
	sepia.r = dot(pixel_col.rgb, vec3(0.393,0.769,0.189));
    sepia.g = dot(pixel_col.rgb, vec3(0.349,0.686,0.168));
    sepia.b = dot(pixel_col.rgb, vec3(0.272,0.534,0.131));
	pixel_col.rgb = mix(pixel_col.rgb,sepia,u_ratio);
    gl_FragColor = pixel_col;
}