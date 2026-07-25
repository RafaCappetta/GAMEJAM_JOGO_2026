extends Marker3D

@export var left: bool = true
@onready var timer: Timer = $Timer

var speed: float = 400.0
var car_scene: PackedScene = preload("res://scenes/car.tscn")

func _ready() -> void:
	timer.timeout.connect(spawn_car)

func spawn_car() -> void:
	print("spawning car")
	var car: RigidBody3D = car_scene.instantiate()
	car.global_transform = global_transform
	car.linear_velocity.z=  speed * (int(!left) * 2 - 1)
	add_sibling(car)
