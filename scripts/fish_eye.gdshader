shader_type canvas_item;
render_mode unshaded;

uniform vec2 center = vec2(0.5);
uniform float power: hint_range(0.1, 10.0, 0.01) = 1.0;
uniform float radius: hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float crop_edge: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform vec4 crop_color: source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 aspect_uv = uv;
    aspect_uv.x *= resolution.x / resolution.y;
    vec2 eye_uv = center;
    eye_uv.x *= resolution.x / resolution.y;
    
    float dist = distance(eye_uv, aspect_uv);
    float warp = clamp(0.5 - pow(dist / radius, 5.0), 0.0, 1.0);
    float mag_factor = pow(warp, 1.0 / power);
    
    if (dist < radius) {
        uv += mag_factor * (center - uv);
    }
    
    vec4 c = textureLod(screen_texture, uv, 0.0);

    if (c.a > 0.0001) {
        c.rgb /= c.a;
    }

    COLOR *= c;

    if (crop_edge > 0.0 && dist > radius - crop_edge) {
        COLOR = mix(COLOR, crop_color, crop_color.a);
    }
}