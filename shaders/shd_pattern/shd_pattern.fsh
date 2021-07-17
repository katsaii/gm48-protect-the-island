varying vec3 v_vPosition;
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

uniform sampler2D s_samplerTexture;
uniform vec2 u_samplerSize;
uniform float u_samplerUVs[8];
uniform vec2 u_samplerOffset;

void main() {
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);
    // correct the dimensions of the sampler UV coordinates
    float u1 = u_samplerUVs[0];
    float v1 = u_samplerUVs[1];
    float u2 = u_samplerUVs[2];
    float v2 = u_samplerUVs[3];
    float dx = u_samplerUVs[4]; // number of pixels trimmed from the left
    float dy = u_samplerUVs[5]; // number of pixels trimmed from the top
    float aa = u_samplerUVs[6]; // ratio of discarded pixels horizontally
    float bb = u_samplerUVs[7]; // ratio of discarded pixels vertically
    float w1 = u_samplerSize.x;
    float h1 = u_samplerSize.y;
    float w2 = (u2 - u1) / aa;
    float h2 = (v2 - v1) / bb;
    float kw = w2 / w1;
    float kh = h2 / h1;
    float u3 = u1 - dx * kw;
    float v3 = v1 - dy * kh;
    float u4 = u3 + w2;
    float v4 = v3 + h2;
    // get sampler texture
    float aw = abs(mod((v_vPosition.x - u_samplerOffset.x) / w1, 1.0));
    float ah = abs(mod((v_vPosition.y - u_samplerOffset.y) / h1, 1.0));
    float u = mix(u3, u4, aw);
    float v = mix(v3, v4, ah);
    vec4 sampler = texture2D(s_samplerTexture, vec2(u, v));
    // ignore textures outside range
    sampler.a *= float(u >= u1 && u <= u2 && v >= v1 && v <= v2);
    // replace base texture with sampler texture
    vec4 col = vec4(sampler.r, sampler.g, sampler.b, min(base.a, sampler.a));
    gl_FragColor = v_vColour * col;
}