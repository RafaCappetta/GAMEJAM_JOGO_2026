extends Node3D

signal animation_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func animation_end():
	animation_ended.emit()
	queue_free()
	
func _process(delta: float) -> void:
	pass
