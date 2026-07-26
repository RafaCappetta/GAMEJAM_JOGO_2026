extends CanvasLayer

func parry():
	var tween = create_tween()
	%ColorRect.modulate.a = 1.0
	tween.tween_property(%ColorRect, "modulate:a", 0.0, 0.5)
	get_tree().paused = true
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false
