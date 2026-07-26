class_name  Heli extends RigidBody3D

@onready var player: CharacterBody3D
var speed = 15
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().current_scene.get_node("%Player")
	var tween = create_tween()
	tween.set_loops(0)
	tween.tween_property(self, "linear_velocity:y", -15.0, 1.0)
	tween.tween_property(self, "linear_velocity:y", 15.0, 1.0)
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	look_at(player.position )
	pass
