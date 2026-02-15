extends Area2D

var active: bool = false
@export var defaultEnemySlowAmount: float
var enemiesInRangeToSlow: Array[CharacterBody2D]
var slowedEnemies: Array[CharacterBody2D]
@onready var beacon: AnimatableBody2D = get_parent()

func _ready() -> void:
	beacon.on_destroyed.connect(UnslowAllEnemies)
	beacon.on_placed.connect(Activate)

func SlowEnemy(enemy: CharacterBody2D):
	slowedEnemies.append(enemy)
	enemy.speedReduction += defaultEnemySlowAmount

func UnslowEnemy(enemy: CharacterBody2D):
	slowedEnemies.remove_at(slowedEnemies.find(enemy))
	enemy.speedReduction -= defaultEnemySlowAmount

func UnslowAllEnemies():
	for enemy in slowedEnemies:
		UnslowEnemy(enemy)

func Activate():
	active = true
	for enemy in enemiesInRangeToSlow:
		SlowEnemy(enemy)

func _on_body_entered(body: Node2D) -> void:
		if body.is_in_group("enemy"):
			enemiesInRangeToSlow.append(body)
			if active:
				SlowEnemy(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRangeToSlow.remove_at(enemiesInRangeToSlow.find(body))
		if slowedEnemies.find(body) != -1:
			UnslowEnemy(body)
