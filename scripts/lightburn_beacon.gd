extends Area2D

var enemiesInRangeToBurn: Array[CharacterBody2D]
var burnedEnemies: Array[CharacterBody2D]


func _on_body_entered(body: Node2D) -> void:
	# if its an enemy, add it to enemiesInRangeToBurn
	if body.is_in_group("enemy"):
		enemiesInRangeToBurn.append(body)
		print(enemiesInRangeToBurn)


func _on_body_exited(body: Node2D) -> void:
	# if its an enemy, remove it from enemiesInRangeToBurn
	if body.is_in_group("enemy"):
		enemiesInRangeToBurn.remove_at(enemiesInRangeToBurn.find(body))
		print(enemiesInRangeToBurn)
