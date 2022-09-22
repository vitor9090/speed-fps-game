shader_type canvas_item;

uniform vec2 target_position;
uniform vec2 self_position;
uniform float distance_multiplier;

void fragment(){
	COLOR = vec4(vec3(1, 1, 1), distance(self_position, target_position) * distance_multiplier);
}