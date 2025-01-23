shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform sampler2D tex : source_color, filter_linear, repeat_enable;
uniform vec2 uv_scale = vec2(1,1);
uniform vec2 uv_speed = vec2(0,0);

uniform sampler2D warp_tex : source_color, repeat_enable;
uniform vec2 warp_uv_scale = vec2(1,1);
uniform vec2 warp_uv_speed = vec2(0,0);
uniform float warp_factor = 1.0;

uniform sampler2D depth_tex : filter_nearest, hint_depth_texture;


void fragment() {
	vec2 uv = (FRAGCOORD.xy / VIEWPORT_SIZE.xy) * uv_scale;
	uv += uv_speed * TIME;
	vec2 warp_uv = (FRAGCOORD.xy / VIEWPORT_SIZE.xy) * warp_uv_scale;
	warp_uv += warp_uv_speed * TIME;
	uv += texture(warp_tex, warp_uv).r * warp_factor;
	ALBEDO = texture(tex, uv).rgb;
}

