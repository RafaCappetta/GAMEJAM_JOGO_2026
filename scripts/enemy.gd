extends CharacterBody3D

@export var life = 50

var player = null

@export var speed = 3.0
@export var damage = 10
var knockback = 70
var can_attack = true

@export var player_path : NodePath

func _ready() -> void:
	player = get_node(player_path)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta 
	
	%GPS.set_target_position(player.global_position)
	var next_nav_point = %GPS.get_next_path_position()
	velocity = (next_nav_point - global_position).normalized() * speed
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

	move_and_slide()

func get_hit(damage):
	life -= damage
	if life <= 0:
		queue_free()

func _on_gps_target_reached() -> void:
	if can_attack:
		var dir = global_position.direction_to(player.global_position)
		dir.y = 0
		dir = dir.normalized()
		player.get_hit(damage, dir, knockback)
		can_attack = false
		%atk_cooldown.start()

func _on_atk_cooldown_timeout() -> void:
	can_attack = true
