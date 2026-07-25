extends CharacterBody3D

@export var life = 60

var alert = false
const TURN_SPEED = 2
var player

var bullet = load("res://scenes/bullet.tscn")
var bullet_instance

func _on_vision_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		alert = true
		player = body
		%shoot_cooldown.start()

func _on_vision_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		alert = false
		if %shoot_cooldown:
			%shoot_cooldown.stop()

func _process(delta: float) -> void:
	if alert:
		%aim.look_at(player.global_transform.origin, Vector3.UP)
		rotate_y(deg_to_rad(%aim.rotation.y * TURN_SPEED))
		rotate_x(deg_to_rad(-%aim.rotation.x * TURN_SPEED * 2))
		rotation.z = 0
		
		
func get_hit(damage):
	life -= damage
	if life <= 0:
		queue_free()

func _on_shoot_cooldown_timeout() -> void:
	bullet_instance = bullet.instantiate()
	add_child(bullet_instance)
