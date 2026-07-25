extends Camera3D


var sky_material: ShaderMaterial

func _ready() -> void:
	var world_env = get_tree().current_scene.get_node("%WorldEnvironment")
	sky_material = world_env.environment.sky.sky_material

func _process(delta: float) -> void:
	sky_material.set_shader_parameter("cam_matrix", global_transform.basis.inverse())
	sky_material.set_shader_parameter("cam_yaw", global_rotation.y)
