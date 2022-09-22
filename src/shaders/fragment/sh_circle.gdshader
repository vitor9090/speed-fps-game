shader_type canvas_item;

// FINISH THIS // !! URGENT !!

uniform float circle_size;
uniform float border_width;
uniform vec3 circle_color;

float circle_algorithm(vec2 map, vec2 position, float size, float border_size, float smoothness){
	return smoothstep(distance(map, position), size, border_size) / smoothness;
}

void fragment(){
	vec2 uv = UV;
	float circle_shape = 0.0;
	
	circle_shape = circle_algorithm(uv, vec2(0.5), circle_size, circle_size-border_width, 0.0);
	
	vec3 color = vec3(circle_shape);
	
	COLOR = vec4(circle_color, circle_algorithm(uv, vec2(0.5), circle_size, 1, 1) + -circle_algorithm(uv, vec2(0.5), circle_size - border_width, 1, 1));
}