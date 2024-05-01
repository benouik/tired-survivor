shader_type canvas_item;

uniform vec2 hit_color = vec2(240, 128);
uniform float intensity = 0.5;
uniform float changing_color = 1.0;

void fragment() {

	float current_a = texture(TEXTURE, UV).a;
	vec4 target_color = mix(texture(TEXTURE, UV), vec4(vec3(hit_color, changing_color), current_a), intensity);
	COLOR = target_color;

}

