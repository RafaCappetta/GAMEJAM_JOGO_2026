extends Node3D

var height_offset = 100
@export var follow_speed: float = 1.0
var ammo = preload("res://scenes/ammo.tscn")

func _ready() -> void:
	get_tree().create_timer(1.0).timeout.connect(shoot_player)
	pass # Replace with function body.


func reload():

	if $"../missile_launcher".get_child(0)== null:
		return
	$"../missile_launcher".get_child(0).queue_free()
	var instance = ammo.instantiate()
	$"../missile_launcher".add_child(instance)
	get_tree().create_timer(5.0).timeout.connect(shoot_player)
func shoot_player():
	var player = get_tree().current_scene.get_node("%Player")
	var missile_launcher =$"../missile_launcher".get_child(0)
	if missile_launcher!= null:
		var missile = missile_launcher.get_child(0)
		if missile == null:
			return reload()
		missile.target(player.position)
		missile.set_as_top_level(true)
		var root_node = get_tree().current_scene
		missile.reparent(root_node)
		
	get_tree().create_timer(0.5).timeout.connect(shoot_player)


func _process(delta: float) -> void:
	var forward_direction = -$"..".global_transform.basis.z
	$"..".linear_velocity = forward_direction * follow_speed
	pass
