extends CharacterBody3D

@export var life = 50

var player = null

@export var speed = 5
@export var damage = 20
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
	var tween = create_tween()
	tween.tween_property(%Sprite3D, "modulate", Color.RED, 0.0)
	tween.tween_property($Sprite3D, "modulate", Color.WHITE, 0.0).set_delay(0.2)
	tween.tween_property(%Sprite3D2, "modulate", Color.RED, 0.0)
	tween.tween_property($Sprite3D2, "modulate", Color.WHITE, 0.0).set_delay(0.2)
	if life <= 0:
		queue_free()

func _on_gps_target_reached() -> void:
	if can_attack:
		player.get_hit(damage)
		%Inimigolamina.play()
		%Sprite3D.frame = 1
		%Sprite3D2.hide()
		can_attack = false
		%atk_anim.start()
		%atk_cooldown.start()

func _on_atk_cooldown_timeout() -> void:
	can_attack = true

func _on_atk_anim_timeout() -> void:
	%Sprite3D.frame = 0
	%Sprite3D2.show()
