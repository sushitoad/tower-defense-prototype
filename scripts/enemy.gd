extends CharacterBody2D

@export var moveToPoint: Vector2
@export var moveSpeed: float = 10

func _physics_process(delta: float) -> void:
	
	if position.distance_to(moveToPoint) > 4:
		velocity = position.direction_to(moveToPoint) * moveSpeed
	
	move_and_slide()
	
func _process(delta: float) -> void:
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
