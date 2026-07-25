extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_sim_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test.tscn")

func _on_nao_pressed() -> void:
	get_tree().quit()

func _on_sim_mouse_entered() -> void:
	%sublinhado1.show()

func _on_sim_mouse_exited() -> void:
	%sublinhado1.hide()

func _on_nao_mouse_entered() -> void:
	%sublinhado2.show()

func _on_nao_mouse_exited() -> void:
	%sublinhado2.hide()
