extends Node2D


@export var enemyTypeOne: PackedScene
@export var enemyTypeTwo: PackedScene
@export var spawnNumberBase: int = 1
@export var enemySpawnRatio: float = 0.5
@export var timeBetweenSpawns: float = 10
@export var spawnDelay: float = 0.3

func _ready() -> void:
	$SpawnTimer.wait_time = timeBetweenSpawns

func _on_spawn_timer_timeout() -> void:
	SpawnAllEnemies()
	
func SpawnAllEnemies():
	var numberToSpawn = spawnNumberBase #and then add the counter in level manager
	var numberOfOne: int = int(roundf(numberToSpawn * enemySpawnRatio))
	var numberOfTwo: int = numberToSpawn - numberOfOne
	SpawnEnemyType(numberOfOne, enemyTypeOne)
	SpawnEnemyType(numberOfTwo, enemyTypeTwo)

func SpawnEnemyType(amount: int, type: PackedScene):
	for num in amount:
		var newEnemy
		newEnemy = type.instantiate()
		add_child(newEnemy)
		newEnemy.global_position = global_position
		await get_tree().create_timer(spawnDelay).timeout
