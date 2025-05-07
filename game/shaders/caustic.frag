extern float anim;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    // Apply sine-based distortion to the UVs
    float waveStrength = 0.02; // How intense the wave is
    float frequency = 30.0;    // How many waves appear
    
    // Offset texture coords to create a wave effect
    vec2 uv = texture_coords;
    uv.y += sin(uv.x * frequency + anim * 3.0) * waveStrength;
    uv.x += sin(uv.y * frequency + anim * 2.0) * waveStrength;
    
    vec4 texturecolor = Texel(tex, uv);
    return texturecolor * color;
}
