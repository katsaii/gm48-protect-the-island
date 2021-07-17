varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_shift;

vec3 rgb2hsv(vec3 col_rgb)
{
	vec4 K = vec4(0.0,-1.0/3.0,2.0/3.0,-1.0);
	vec4 P = mix( vec4(col_rgb.b,col_rgb.g,K.w,K.z), vec4(col_rgb.g,col_rgb.b,K.x,K.y), step(col_rgb.b,col_rgb.g) );
	vec4 Q = mix( vec4(P.x,P.y,P.w,col_rgb.r), vec4(col_rgb.r,P.y,P.z,P.x), step(P.x,col_rgb.r) );
	
	float D = Q.x - min(Q.w,Q.y);
	float E = 1.0e-10;
	return vec3( abs(Q.z+(Q.w-Q.y)/(6.0*D+E)), D/(Q.x+E), Q.x );
}

vec3 hsv2rgb(vec3 col_hsv)
{
	vec4 K = vec4(1.0,2.0/3.0,1.0/3.0,3.0);
	vec3 P = abs( fract(col_hsv.xxx + K.xyz )*6.0-K.www );
	return col_hsv.z*mix( K.xxx, clamp(P-K.xxx,0.0,1.0), col_hsv.y );
}

void main()
{
	// Credit: KeeVee Games
    vec4 pixel_col = v_vColour*texture2D(gm_BaseTexture,v_vTexcoord);
	vec3 col_hsv = rgb2hsv(pixel_col.rgb);
	col_hsv.x += u_shift; // shift colour
	pixel_col.rgb = hsv2rgb(col_hsv);
	gl_FragColor = pixel_col;
}
