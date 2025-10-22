extends Area2D

#if it doesn't have a target and something enters area
#that becomes its target
#attacks the target by sending little bullets?

@export var attackSpeed: float = 1
@export var attackDamage: int = 10
var attackRange: float
var currentTarget: CharacterBody2D

func _ready() -> void:
	var circleShape: Shape2D = $CollisionShape2D.shape
	attackRange = circleShape.radius

func _process(delta: float) -> void:
	if currentTarget == null:
		var enemiesInRange = []
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if position.distance_to(enemy.position) <= attackRange:
				enemiesInRange.append(enemy)
		if enemiesInRange.size() != 0:
			print("found enemy")
	#find the closest one and set it to current target

func _on_body_exited(body: Node2D) -> void:
	if currentTarget == body:
		currentTarget = null
