extends Node3D

var is_shaking := false

func _input(event: InputEvent) -> void:
	if event.is_action("debug"):
		shake_pos(0.8, 1)

func shake_pos(intensity: float = 0.2, duration: float = 0.3) -> void:
	if is_shaking: return
	is_shaking = true
	
	var time_left := duration
	var start_position = position
	
	while time_left > 0:
		var offset := Vector3(randf_range(-intensity, intensity), randf_range(-intensity, intensity), 0.0)
		
		%camera.position = start_position + offset
		time_left -= get_process_delta_time()
		
		await get_tree().process_frame
		
	position = start_position
	is_shaking = false
