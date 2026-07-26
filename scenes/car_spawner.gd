extends Marker3D

@export var x_axis: bool = false
@export var left: bool = true

@onready var timer: Timer = $Timer
var car_life_time = 5
var speed: float = 400.0
var car_scene: PackedScene = preload("res://scenes/car.tscn")

func _ready() -> void:
	timer.timeout.connect(spawn_car)

func spawn_car() -> void:
	var car: RigidBody3D = car_scene.instantiate()
	car.global_transform = global_transform
	if int(x_axis) == 0:
		car.linear_velocity.z=  speed * (int(!left) * 2 - 1)
		look_at(Vector3(0,left,0))
	if int(x_axis) == 1: 
		car.linear_velocity.x=  speed * (int(!left) * 2 - 1)
		look_at(Vector3(left,0,0))
	
	add_sibling(car)
	get_tree().create_timer(5).timeout.connect(car.queue_free)
