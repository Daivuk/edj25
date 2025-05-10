extern float anim;
extern float camera_zoom;
extern vec2 camera_pos;
extern vec2 res;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texturecolor = vec4(0, 0, 0, 0);
    float strenght = 1;
    float cam_zoom = camera_zoom;
    vec2 cam_pos = camera_pos;
    for (int i = 0; i < 8; ++i)
    {
        texture_coords = ((screen_coords - res * 0.5) / cam_zoom + cam_pos) / 2048 * 8;
        cam_zoom += 0.02;
        cam_pos.y += 2;

        // Apply sine-based distortion to the UVs
        float waveStrength = 0.02; // How intense the wave is
        float frequency = 30.0;    // How many waves appear
        
        // Offset texture coords to create a wave effect
        vec2 uv = texture_coords;
        uv.y += sin(uv.x * frequency + anim * 3.0) * waveStrength;
        uv.x += sin(uv.y * frequency + anim * 2.0) * waveStrength;

        texturecolor += Texel(tex, uv) * strenght;
        strenght /= 1.6;
    }

    return texturecolor * color * 0.15;
}
