extends Area2D


@export var defaultEnemySlowAmount: float
var slowedEnemies: Array[CharacterBody2D]
@onready var beacon: AnimatableBody2D = get_parent()

func SlowEnemy(enemy: CharacterBody2D):
	slowedEnemies.append(enemy)
	enemy.speedReduction += defaultEnemySlowAmount

func UnslowEnemy(enemy: CharacterBody2D):
	slowedEnemies.remove_at(slowedEnemies.find(enemy))
	enemy.speedReduction -= defaultEnemySlowAmount


func _on_body_entered(body: Node2D) -> void:
	pass # adds slow to enemies once placed- can beacon script be in charge of once placed part?


func _on_body_exited(body: Node2D) -> void:
	pass # unslows enemies when they leave range
