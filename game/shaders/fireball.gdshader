shader_type spatial;
render_mode blend_add, cull_disabled;

uniform sampler2D gradient;
uniform sampler2D fire;
uniform sampler2D colour;
uniform float amount;

void fragment() {
	ALBEDO = vec3(0.0, 0.0, 0.0);
	vec2 uv_a = (UV * vec2(0.5, 1.0)) + vec2(TIME, 0.0);
	vec2 uv_b = UV + vec2(TIME * 2.0, 0.0);
	float a = texture(gradient, uv_a).r;
	float b = texture(fire, uv_b).r;
	float c = (a * a) * b;
	vec3 v = texture(colour, vec2(1.0 - c, 0.0)).rgb;
	EMISSION.rgb = v * 2.0 * amount;
}