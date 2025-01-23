shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,depth_prepass_alpha;

uniform sampler2D grayscale_texture : source_color, filter_nearest, repeat_enable;
uniform vec4 modulate : source_color;
uniform float uv_scale = 1.0;
uniform float alpha_falloff = 1.0;
uniform vec2 scroll_speed;

void vertex() {
	UV += vec2(TIME * scroll_speed.x, TIME * scroll_speed.y);
	UV *= uv_scale;
}

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	vec4 tex = texture(grayscale_texture, UV);
	ALBEDO = (tex * modulate).rgb;
	ALPHA = pow((tex.r+tex.g+tex.b)/3.0, alpha_falloff);
}



//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}


