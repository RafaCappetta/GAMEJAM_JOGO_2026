extends Node3D

signal animation_ended


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sounds = ["res://resources/vfx/explosion_sound/boom2.wav",
	"res://resources/vfx/explosion_sound/boom3.wav",
	"res://resources/vfx/explosion_sound/boom4.wav",
	"res://resources/vfx/explosion_sound/boom5.wav",
	"res://resources/vfx/explosion_sound/boom6.wav",
	]
	var sound = load(sounds[randi_range(0, 4)])
	$AudioStreamPlayer3D.stream = sound
	$AudioStreamPlayer3D.play()
	pass # Replace with function body.


func animation_end():
	animation_ended.emit()
	queue_free()
	
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("found player")	
	body.screen_shake(0.5, 0.7)
	body.get_hit(20)


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
