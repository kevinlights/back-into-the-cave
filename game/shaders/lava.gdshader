shader_type canvas_item;

void fragment() {
	vec2 uv = UV + vec2(sin(TIME + UV.y), 0.0);
	COLOR.rgba = texture(TEXTURE, uv);
}