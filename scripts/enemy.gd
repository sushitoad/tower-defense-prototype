extends CharacterBody2D

var currentTarget: Node2D
@export var moveSpeed: float = 10
@export var range: float = 20

func _ready() -> void:
	FindTarget()

func _physics_process(delta: float) -> void:
	if position.distance_to(currentTarget.position) > range:
		velocity = position.direction_to(currentTarget.position) * moveSpeed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
func _process(delta: float) -> void:
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
		
func FindTarget():
	var closestTarget: Vector2 = Vector2(10000000000, 10000000000)
	var closestAllure: float = 1
	for target in get_tree().get_nodes_in_group("tower"):
		if (target.position.distance_to(position) / target.allure) < (closestTarget.distance_to(position) / closestAllure):
			closestTarget = target.position
			closestAllure = target.allure
			currentTarget = target
	
	
