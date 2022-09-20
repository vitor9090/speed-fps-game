shader_type canvas_item;

uniform vec2 u_resolution;

void fragment(){
	vec2 uv = SCREEN_UV/u_resolution;
	// vec2 pixel_uv = round(uv) / u;
	COLOR = texture(SCREEN_TEXTURE, uv * u_resolution);
}