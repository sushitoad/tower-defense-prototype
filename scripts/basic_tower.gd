extends Area2D

#attacks the target by sending little bullets?

@export var attackSpeed: float = 1
@export var attackDamage: int = 10
var attackRange: float
var enemiesInRange = Array()
var currentTarget: CharacterBody2D
var tower: StaticBody2D

func _ready() -> void:
	var circleShape: Shape2D = $CollisionShape2D.shape
	attackRange = circleShape.radius
	tower = get_parent()

func _process(delta: float) -> void:
	if currentTarget == null:
		if !enemiesInRange.is_empty():
			var closestEnemy = enemiesInRange[0]
			for enemy in enemiesInRange:
				if position.distance_to(enemy.position) < position.distance_to(closestEnemy.position):
					closestEnemy = enemy
			currentTarget = closestEnemy
	#print(currentTarget)

func _on_body_exited(body: Node2D) -> void:
	if currentTarget == body:
		currentTarget = null
	enemiesInRange.remove_at(enemiesInRange.find(body))
	#if body is a bullet that is also a child of this delete the bullet

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRange.append(body)

func SpawnBullet():
	pass
	#instantiate a bullet
	#give the bullet a target
	#bullet will have its own script that propels it toward the target 
