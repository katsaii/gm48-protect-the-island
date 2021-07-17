varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_intensity;

void main()
{
	// Credit: KeeVee Games
	vec4 pixel_col = v_vColour*texture2D(gm_BaseTexture,v_vTexcoord);
	float col_max = max(pixel_col.r,max(pixel_col.g,pixel_col.b)); // get max pixel channel
	float col_min = min(pixel_col.r,min(pixel_col.g,pixel_col.b)); // get min pixel channel
	// scale pixel saturation based on uniform ratio
	pixel_col.r = clamp(col_max-(col_max-pixel_col.r)*u_intensity,0.0,col_max);
	pixel_col.g = clamp(col_max-(col_max-pixel_col.g)*u_intensity,0.0,col_max);
	pixel_col.b = clamp(col_max-(col_max-pixel_col.b)*u_intensity,0.0,col_max);
    gl_FragColor = pixel_col;
}