shader_type spatial;
render_mode blend_add, cull_disabled;

uniform sampler2D gradient;
uniform sampler2D clouds;
uniform sampler2D colour;
uniform float amount = 1.0;

void fragment() {
	ALBEDO = vec3(0.0, 0.0, 0.0);
	vec2 flame_uv_a = UV + vec2(TIME * 0.5, TIME * 0.5);
	vec2 flame_uv_b = UV + vec2(TIME * 0.125, TIME * 0.5);
	float grad = texture(gradient, UV).r * amount;
	float flame_a = texture(clouds, flame_uv_a).r;
	float flame_b = texture(clouds, flame_uv_b).g;
	float flame = min(flame_a * flame_b * 2.0 * amount, 1.0);
	vec3 flame_colour = texture(colour, vec2(flame, 0.0)).rgb;
	flame_colour.g *= 0.5;
	EMISSION = flame_colour * grad * 4.0;
}