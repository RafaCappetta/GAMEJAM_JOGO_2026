extends Control

var paused = false

func _on_resume_pressed() -> void:
	pause()

func _on_quit_pressed() -> void:
	get_tree().quit()

func pause():
	if paused:
		hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		show()
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	paused = !paused
