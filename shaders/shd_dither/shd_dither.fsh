varying vec3 v_vPosition;
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

uniform float u_intensity;

float rgb_luminance(vec3 col_rgb)
{
	return 0.2126*col_rgb.r + 0.7152*col_rgb.g + 0.0722*col_rgb.b;
}

float dithered(vec2 pixel_position, vec4 pixel_colour)
{
	/* patterns:
	 * 1     2      3
	 * -----------------
	 * # #   # #    # # 
	 *          #    # #
	 * # #   # #    # # 
	 *        #      # #
	 */
	bool dith_1 = (mod(pixel_position.x,2.0)<1.0)&&(mod(pixel_position.y,2.0)<1.0);
	bool dith_2 = dith_1||
				((mod(pixel_position.x-3.0,4.0)<1.0)&&(mod(pixel_position.y-1.0,4.0)<1.0))||
				((mod(pixel_position.x-1.0,4.0)<1.0)&&(mod(pixel_position.y-3.0,4.0)<1.0));
	bool dith_3 = dith_1||
				((mod(pixel_position.x+1.0,2.0)<1.0)&&(mod(pixel_position.y+1.0,2.0)<1.0));
	vec4 dith_patterns = vec4(float(dith_3),float(dith_2),float(dith_1),0.0);
	int  dith_band = int(clamp( rgb_luminance(pixel_colour.rgb)*(4.0/3.0),0.0,3.0 ));
	return(dith_patterns[dith_band]);
}

void main()
{
	vec4 pixel_col = v_vColour*texture2D(gm_BaseTexture,v_vTexcoord);
	float pixel_is_dithered = dithered(v_vPosition.xy,pixel_col*(u_intensity + 0.75)); // either 0.0 or 1.0
	float pixel_isNot_dithered = (pixel_is_dithered*-1.0)+1.0;
	
	pixel_col.rgb *= pixel_isNot_dithered; // if not dithered then col = original, otherwise col = <0.0,0.0,0.0> a.k.a. black
		
	gl_FragColor = pixel_col;
}