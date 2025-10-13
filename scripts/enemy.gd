extends CharacterBody2D

var moveToPoint: Vector2
@export var moveSpeed: float = 10
@export var range: float = 20

func _ready() -> void:
	FindTarget()

func _physics_process(delta: float) -> void:
	if position.distance_to(moveToPoint) > range:
		velocity = position.direction_to(moveToPoint) * moveSpeed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
func _process(delta: float) -> void:
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
		
func FindTarget():
	print("finding target")
	var closestTarget: Vector2 = Vector2(10000000000, 10000000000)
	for target in get_tree().get_nodes_in_group("target"):
		if target.position.distance_to(position) < closestTarget.distance_to(position):
			closestTarget = target.position
	moveToPoint = closestTarget
	
	
