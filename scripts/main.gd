extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		%Pause_menu.pause()

func _on_fog_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		%Tomadano.play()
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")


func _on_pcarea_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://scenes/gamewin.tscn")
