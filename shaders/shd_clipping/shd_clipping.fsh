varying vec3 v_vPosition;
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

uniform vec2 u_pointA;
uniform vec2 u_pointB;

void main() {
    bool visible = (v_vPosition.x >= u_pointA.x) && (v_vPosition.x <= u_pointB.x) &&
            (v_vPosition.y >= u_pointA.y) && (v_vPosition.y <= u_pointB.y);
    vec4 col = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    col.a *= float(visible);
    gl_FragColor = col;
}