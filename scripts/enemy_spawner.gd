extends Node2D

@export var enemyToSpawn: PackedScene
@export var timeBetweenSpawns: float = 10
@export var numberToSpawn: int = 1
@export var spawnDelay: float = 0.3

#the best version of this can spawn enemies of multiple types based on ratios
#multiple enemies, spaced apart initially based on their collision shape size (half size?)

func _ready() -> void:
	$SpawnTimer.wait_time = timeBetweenSpawns

func _on_spawn_timer_timeout() -> void:
	SpawnEnemies()
	
func SpawnEnemies():
	for num in numberToSpawn:
		var newEnemy
		newEnemy = enemyToSpawn.instantiate()
		add_child(newEnemy)
		newEnemy.global_position = global_position
		await get_tree().create_timer(spawnDelay).timeout
