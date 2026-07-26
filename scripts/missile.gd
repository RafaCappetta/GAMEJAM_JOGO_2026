extends RigidBody3D

@export var active: bool = false

var explosion = preload("res://resources/vfx/actual_missile_explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var tween = create_tween()
	#tween.tween_interval(5.0)
	#await tween.finished
	#explode()
	pass # Replace with function body.


func target(pos:Vector3):
	$AnimationPlayer.play(&"launch")
	var speed = 20.0
	var forward_direction = -global_transform.basis.z
	linear_velocity = forward_direction * speed
	$Area3D.monitoring = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func explode():
	if $asset == null:
		return
	$asset.queue_free()
	var instance = explosion.instantiate()
	add_child(instance)
	$Area3D.monitoring = false
	linear_velocity = Vector3.ZERO
	instance.animation_ended.connect(queue_free)


func _on_area_3d_body_entered(body: Node3D) -> void:
	explode()
