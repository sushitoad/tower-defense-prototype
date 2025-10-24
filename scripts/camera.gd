extends Camera2D

@export var cameraSpeed: float = 400

func _ready() -> void:
	var towers = get_tree().get_nodes_in_group("tower")
	for tower in towers:
		if tower.name == "TheHeartfire":
			global_position = tower.global_position

func _process(delta: float) -> void:
	var moveDirection = Input.get_vector("CameraLeft", "CameraRight", "CameraUp", "CameraDown")
	global_position += moveDirection * cameraSpeed * delta
