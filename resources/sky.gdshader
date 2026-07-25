shader_type sky;


uniform vec3 sky_color : source_color;
uniform vec3 line_color : source_color = vec3(0.0, 1.0, 1.0);
uniform float line_distance : hint_range(0.1, 50.0) = 5.0;
uniform float line_thickness  = 0.01;
uniform float parallax_speed : hint_range(0.0, 0.5) = 0.05;

uniform mat3 cam_matrix;
uniform float cam_yaw;
void sky() {
	vec3 screen_dir = cam_matrix * EYEDIR;
    float angle = atan(screen_dir.x, screen_dir.z);
	float offset = cam_yaw * parallax_speed;
    float pattern = fract((angle * line_distance) + offset);
    float is_line = smoothstep(line_thickness, max(0.0, line_thickness - 0.02), pattern);
    COLOR = mix(sky_color, line_color, is_line);
}