extends Area2D

#if it doesn't have a target and something enters area
#that becomes its target
#attacks the target by sending little bullets?

@export var attackSpeed: float = 1
@export var attackDamage: int = 10
var attackRange: float
var currentTarget: CharacterBody2D
var tower: StaticBody2D

func _ready() -> void:
	var circleShape: Shape2D = $CollisionShape2D.shape
	attackRange = circleShape.radius / 100
	tower = get_parent()

func _process(delta: float) -> void:
	if currentTarget == null:
		var enemies = get_tree().get_nodes_in_group("enemy")
		for enemy in enemies:
			if tower.position.distance_to(enemy.position) > attackRange:
				#i think this thinning the list approach is just not gonna work
				#for some reason it keeps one of the enemies in the array even when it should be out of range
				#so its either the array logic, or the distance logic, and I did a solid cursory check of distance
				enemies.remove_at(enemies.find(enemy))
		var closestEnemy: CharacterBody2D
		print(enemies.size())

	#find the closest one and set it to current target

func _on_body_exited(body: Node2D) -> void:
	if currentTarget == body:
		currentTarget = null
