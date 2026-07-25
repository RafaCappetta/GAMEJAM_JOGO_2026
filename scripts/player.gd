extends CharacterBody3D

#PULO DUPLO - OK
#CORRIDA - OK
#DASH - OK
#MOVIMENTO DA CABEÇA - OK
#FOV - OK
#VIDA - OK
# DAR DANO - OK
#CORRIDA NA PAREDE

var life = 100

var punch_damage = 30

const SPEED = 5.0
const RUN_SPEED = 7.5
var total_speed = SPEED

const DASH = 100
var can_dash = true

const JUMP_VELOCITY = 10
var can_double_jump = true

const CAM_SENSITIVITY = 0.005

var time_bob = 0.0
const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.08

const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

@onready var head : Node3D = $head

var tween: Tween
var dash_velocity = 0

var eletric_punch = false

func _ready() -> void:
	add_to_group("Player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * CAM_SENSITIVITY)
		%camera.rotate_x(-event.relative.y * CAM_SENSITIVITY)
		%camera.rotation.x = clamp(%camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		
func _process(delta: float) -> void:
	if life <= 25:
		%screen_color.color.a = 0.15
		%sprite.frame = 2
	elif life <= 50:
		%screen_color.color.a = 0.075
		%sprite.frame = 1
	else:
		%screen_color.color.a = 0
		%sprite.frame = 0

	%life.text = "%d" % life
	

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta 

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if not is_on_floor() and can_double_jump:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
			can_double_jump = false
	elif is_on_floor():
		can_double_jump = true
		
	if Input.is_action_pressed("run"):
		total_speed = SPEED + RUN_SPEED
	else:
		total_speed = SPEED
		
		
	if Input.is_action_just_pressed("dash") and can_dash:
		dash_velocity = DASH
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(self, "dash_velocity", 0, 0.3).set_ease(Tween.EASE_OUT)
		%dash_cooldown.start()
		can_dash = false
		
	if Input.is_action_just_pressed("soco") and eletric_punch:
		%soco_hitbox.global_transform.basis = %camera.global_transform.basis
		%soco_hitbox.monitoring = true
		%soco_timer.start()
		%animacao.play("soco")
		eletric_punch = false

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * (total_speed + dash_velocity)
		velocity.z = direction.z * (total_speed + dash_velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, total_speed)
		velocity.z = move_toward(velocity.z, 0, total_speed)
		
	time_bob += delta * velocity.length() * float(is_on_floor())
	%camera.transform.origin = head_bobbing(time_bob)
	
	var velocity_clamped = clamp(velocity.length(), 0.5, RUN_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	%camera.fov = lerp(%camera.fov, target_fov, delta * 8.0)

	move_and_slide()

func head_bobbing(time_bob):
	var pos = Vector3.ZERO
	pos.y = sin(time_bob * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time_bob * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	return pos

func get_hit(damage):
	life -= damage
	if life <= 0:
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func _on_soco_timer_timeout() -> void:
	%soco_hitbox.monitoring = false

func _on_soco_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		body.get_hit(punch_damage)
