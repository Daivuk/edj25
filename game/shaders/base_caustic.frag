extern float anim;
extern Image caustic_tex;
extern float camera_zoom;
extern vec2 camera_pos;
extern vec2 res;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 basecolor = Texel(tex, texture_coords);

    texture_coords = ((screen_coords - res * 0.5) / camera_zoom + camera_pos) / 2048 * 16;

    // Apply sine-based distortion to the UVs
    float waveStrength = 0.01; // How intense the wave is
    float frequency = 30.0;    // How many waves appear
    
    // Offset texture coords to create a wave effect
    vec2 uv = texture_coords;
    uv.y += sin(uv.x * frequency + anim * 3.0) * waveStrength;
    uv.x += sin(uv.y * frequency + anim * 2.0) * waveStrength;
    
    vec4 causticcolor = Texel(caustic_tex, uv);
    causticcolor *= color * basecolor.a * 0.25;
    return basecolor * color + causticcolor;
}
