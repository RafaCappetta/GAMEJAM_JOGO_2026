shader_type sky;


uniform vec3 sky_color : source_color;
uniform vec3 line_color : source_color = vec3(0.0, 1.0, 1.0);
uniform float line_distance : hint_range(0.1, 50.0) = 5.0;
uniform float line_thickness  = 0.01;
void sky() {
	float angle = atan(EYEDIR.x, EYEDIR.z);
	float pattern = fract(angle * line_distance);
	float is_line = step(pattern, 0.01);
	COLOR = mix(sky_color, line_color, is_line);
}
