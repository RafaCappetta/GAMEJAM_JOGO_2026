extends Area3D

var speed = 0.67
var damage = 10
var parry = false

var velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	
	if parry:
		velocity.z = 1
	else:
		velocity.z = -1
	translate(velocity.normalized() * speed)
		

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if parry:
		if body.is_in_group("Enemy"):
			body.get_hit(damage)
			queue_free()
		else:
			queue_free()
	else:
		if body.is_in_group("Player"):
			body.get_hit(damage)
			queue_free()
		else:
			queue_free()
