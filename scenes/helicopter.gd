extends RigidBody3D

@onready var player: CharacterBody3D
var speed = 15
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().current_scene.get_node("%Player")

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	look_at(player.global_position )
