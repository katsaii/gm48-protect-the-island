varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_ratio;

void main()
{
	// Credit: Xygthop3
	vec4 pixel_col = v_vColour*texture2D( gm_BaseTexture, v_vTexcoord );
	float grey = dot(pixel_col.rgb,vec3(0.21,0.71,0.07));
    gl_FragColor = vec4(mix(pixel_col.rgb,vec3(grey),u_ratio),pixel_col.a);
}