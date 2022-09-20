shader_type canvas_item;

uniform vec3 color_modifier;

void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	color.rgb = floor(color.rgb * color_modifier) / color_modifier;
	// vec2 resolution = vec2(0.008, 0.008);
	// vec2 uv = SCREEN_UV;
	// uv -= mod(uv, resolution);
	COLOR.rgb = color.rgb;
}