extends Area2D

#if it doesn't have a target and something enters area
#that becomes its target
#attacks the target by sending little bullets?

@export var attackSpeed: float = 1
@export var attackDamage: int = 10
@export var attackRange: float = 100
var currentTarget: CharacterBody2D

func _process(delta: float) -> void:
	if currentTarget == null:
		pass
	#make an array of all enemies in range
	#find the closest one and set it to current target

#this wont work, it will need to check its range for something in group enemy on every frame it currently doesn't have a target
func _on_body_entered(body: Node2D) -> void:
	if currentTarget == null:
		if body.is_in_group("enemy"):
			currentTarget = body

func _on_body_exited(body: Node2D) -> void:
	if currentTarget == body:
		currentTarget = null
