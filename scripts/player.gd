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
var tough_dash_damage = 60

const SPEED = 5.0
const RUN_SPEED = 7.5
var total_speed = SPEED

const TOUGH_DASH = 200
var can_tough_dash = false
var carregando_tough_dash = false


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

"""------Wallrunning------"""

"""Wallrun Nodepath"""
@export var wallrun_node_path: NodePath

"""Referencia ao Wallrun Nodepath"""
@onready var wallrun_node = get_node(wallrun_node_path)

"""If wallrun is allowed"""
var can_wallrun = false
var wallrun_delay = 0.2
@onready var wallrun_delay_default = wallrun_delay
var wallrun_time_exceeded = false

"""To know if is Wallrunning"""
var is_wallrunning

"""Wallrunning Rotation"""
@export var wallrun_angle: float = 15
var wallrun_current_angle = 0
var side = ""

@onready var head : Node3D = $head

var tween: Tween
var dash_velocity = 0
var eletric_punch = 0

func _ready() -> void:
	add_to_group("Player")
	%Tough_dash_hitbox.monitoring = false
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
		%Pulo.play()
		
	if not is_on_floor():
		if can_double_jump:
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
				can_double_jump = false
				%Pulo.play()
		
		wallrun_delay = clamp(wallrun_delay - delta, 0, wallrun_delay_default)
		
		if wallrun_delay == 0 and not wallrun_time_exceeded:
			can_wallrun = true
		
	elif is_on_floor():
		can_double_jump = true
		is_wallrunning = false
		can_wallrun = false
		wallrun_delay = wallrun_delay_default
		wallrun_time_exceeded = false
		
	if Input.is_action_pressed("run"):
		total_speed = SPEED + RUN_SPEED
	else:
		total_speed = SPEED
		
		
	if Input.is_action_just_pressed("dash") and can_dash:
		dash_velocity = DASH
		%Dash.play()
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(self, "dash_velocity", 0, 0.3).set_ease(Tween.EASE_OUT)
		%dash_cooldown.start()
		can_dash = false
	
	if Input.is_action_just_pressed("release_skill"):
		%Tough_dash_charge.start()
		can_tough_dash = false
		carregando_tough_dash = true
		%Tough_dash_hitbox.monitoring = false
	
	if Input.is_action_just_released("release_skill"):
		if can_tough_dash:
			can_tough_dash = false
			carregando_tough_dash = false
			dash_velocity = TOUGH_DASH
			%Tough_dash_hitbox.global_transform.basis = %camera.global_transform.basis
			%Tough_dash_hitbox.monitoring = true
			%Tough_dash_hits.start()
			
			if tween:
				tween.stop()
			tween = create_tween()
			tween.tween_property(self, "dash_velocity", 0, 0.3).set_ease(Tween.EASE_OUT)
		else:
			carregando_tough_dash = false
			%Tough_dash_charge.stop()
	
	if Input.is_action_just_pressed("soco") and eletric_punch > 0:
		%soco_hitbox.global_transform.basis = %camera.global_transform.basis
		%soco_hitbox.monitoring = true
		%soco_timer.start()
		%animacao.play("soco")
		%Socorelampago.play()
		eletric_punch -= 1

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			if not %Corrida.playing:
				%Corrida.play()
		else:
			%Corrida.stop()
		velocity.x = direction.x * (total_speed + dash_velocity)
		velocity.z = direction.z * (total_speed + dash_velocity)
	else:
		%Corrida.stop()
		velocity.x = move_toward(velocity.x, 0, total_speed)
		velocity.z = move_toward(velocity.z, 0, total_speed)
		
	time_bob += delta * velocity.length() * float(is_on_floor())
	%camera.transform.origin = head_bobbing(time_bob)
	
	var velocity_clamped = clamp(velocity.length(), 0.5, RUN_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	%camera.fov = lerp(%camera.fov, target_fov, delta * 8.0)
	
	if can_wallrun:
		if is_on_wall() and Input.is_action_pressed("up") and Input.is_action_pressed("run"):
			
			"""Get collision data and its normal"""
			var collision = get_slide_collision(0)
			var normal = collision.get_normal()
			
			"""Calculate the direction on which that player shall move"""
			var wallrun_dir = Vector3.UP.cross(normal)
			
			var player_view_dir = %camera.global_transform.basis.z
			var dot = wallrun_dir.dot(player_view_dir)
			if dot < 0:
				wallrun_dir = -wallrun_dir
			
			"""Add small push towards the wall"""
			wallrun_dir += -normal * 0.01
			
			"""Enable Wallrunning"""
			is_wallrunning = true
			
			if %Wallrun_timer.is_stopped():
				%Wallrun_timer.start()
			
			"""Set side to a string, telling which side of player the wall is"""
			side = get_side_wall(collision.get_position())
			
			"""Setting vertical velocity close to 0 and moving direction the newly calculated wallrun direction"""
			velocity.y = -0.01
			direction = wallrun_dir
		
		else:
			is_wallrunning = false
			%Wallrun_timer.stop()
			wallrun_time_exceeded = false
	
	"""Tilt the view"""
	if is_wallrunning:
		print("wallrunning, side: ", side, " angle: ", wallrun_current_angle)
		if side == "RIGHT":
			wallrun_current_angle += delta * 60
			wallrun_current_angle = clamp(wallrun_current_angle, -wallrun_angle, wallrun_angle)
		elif side == "LEFT":
			wallrun_current_angle -= delta * 60
			wallrun_current_angle = clamp(wallrun_current_angle, -wallrun_angle, wallrun_angle)
	
	#Return back to normal view
	else:
		if wallrun_current_angle > 0:
			wallrun_current_angle -= delta * 40
			wallrun_current_angle = max(0, wallrun_current_angle)
		elif wallrun_current_angle < 0:
			wallrun_current_angle += delta * 40
			wallrun_current_angle = min(wallrun_current_angle, 0)
	
	wallrun_node.rotation_degrees = Vector3(0, 0, 1) * wallrun_current_angle
	move_and_slide()

func head_bobbing(time_bob):
	var pos = Vector3.ZERO
	pos.y = sin(time_bob * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time_bob * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	return pos

func get_hit(damage):
	life -= damage
	%Tomadano.play()
	if life <= 0:
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func _on_soco_timer_timeout() -> void:
	%soco_hitbox.monitoring = false

func _on_soco_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		body.get_hit(punch_damage)

func get_side_wall(collision_point):
	var to_wall = collision_point - global_position
	var right = head.global_transform.basis.x
	var dot_right = to_wall.dot(right)
	
	if dot_right > 0:
		return "RIGHT"
	elif dot_right < 0:
		return "LEFT"
	else:
		return "CENTER"
	
func _on_soco_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("Bullet"):
		%Parry.play()
		print("PARRY")
		%Parry_light.parry()
		area.parry = true

func _on_tough_dash_charge_timeout() -> void:
	if carregando_tough_dash:
		can_tough_dash = true

func _on_tough_dash_hits_timeout() -> void:
	%Tough_dash_hitbox.monitoring = false

func _on_tough_dash_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		body.get_hit(tough_dash_damage)

func _on_wallrun_timer_timeout() -> void:
	is_wallrunning = false
	can_wallrun = false
	wallrun_time_exceeded = true
