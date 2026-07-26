extends Control

func _on_novo_jogo_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading.tscn")

func _on_continuar_pressed() -> void:
	%Tomadano.play()

func _on_sair_pressed() -> void:
	get_tree().quit()
