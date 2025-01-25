shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform sampler2D warp_tex : source_color, repeat_enable, filter_linear;
uniform vec2 warp_uv_scale = vec2(1,1);
uniform vec2 warp_uv_speed = vec2(0,0);
uniform float warp_factor = 1.0;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest, repeat_disable;


void fragment() {
	vec2 uv = SCREEN_UV * TIME;
	vec2 warp_uv = UV * warp_uv_scale;
	warp_uv += warp_uv_speed * TIME;
	float warp = texture(warp_tex, warp_uv).r * warp_factor;
	
	ALBEDO = textureLod(screen_tex, uv, 0.0).rgb;
	vec3 st = textureLod(screen_tex, SCREEN_UV+warp, 0.0).rgb;
	ALBEDO = st;
	//ALBEDO = vec3(warp);
}

