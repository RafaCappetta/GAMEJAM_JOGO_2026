extends Area3D

var speed = 1
var damage = 10

var velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	
	velocity.z = -1
	translate(velocity.normalized() * speed)

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.get_hit(damage)
		queue_free()
	else:
		queue_free()
