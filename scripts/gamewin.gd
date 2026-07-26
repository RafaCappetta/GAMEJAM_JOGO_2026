extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo():
		%video.play()

func _on_video_finished() -> void:
	get_tree().quit()
