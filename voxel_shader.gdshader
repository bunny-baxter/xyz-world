shader_type spatial;

uniform sampler2D uv_map;

void vertex() {
}

void fragment() {
	ALBEDO = texture(uv_map, UV).rgb;
}
