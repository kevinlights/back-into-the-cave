shader_type spatial;
render_mode blend_add, cull_back;

uniform sampler2D world;

void fragment() {
	ALBEDO = vec3(0.0);
	vec3 cave = texture(world, UV * vec2(-1.0, 1.0)).rgb * NORMAL.b * vec3(0.7, 0.85, 1.0);
	float b = (cave.r + cave.g + cave.b) / 3.0;
	cave *= b;
	EMISSION = cave;
}