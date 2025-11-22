extends Node2D


@export var enemyTypeOne: PackedScene
@export var enemyTypeTwo: PackedScene
@export var spawnNumberBase: int = 1
@export var enemySpawnRatio: float = 0.5
@export var timeBetweenSpawns: float = 10
@export var timeToIncreaseSpawns: float = 30
@export var spawnDelay: float = 0.3
@export var activatesLater: bool = false
@export var activationTime: float = 120
var activated: bool = false
var timeOfActivation: float
var levelManager: Node

func _ready() -> void:
	$SpawnTimer.wait_time = timeBetweenSpawns
	levelManager = get_parent().get_node("LevelManager")
	if activatesLater:
		$SpawnTimer.stop()
		$Sprite2D.visible = false
		activated = false
	else:
		activated = true
		timeOfActivation = levelManager.timeSinceLevelLoad

func _process(delta: float) -> void:
	if activatesLater:
		if !activated:
			if levelManager.timeSinceLevelLoad >= activationTime:
				$SpawnTimer.start()
				$Sprite2D.visible = true
				activated = true
				timeOfActivation = levelManager.timeSinceLevelLoad
				print(self.name + " activated")

func _on_spawn_timer_timeout() -> void:
	SpawnAllEnemies()
	
func SpawnAllEnemies():
	var numberToSpawn = spawnNumberBase + roundi((levelManager.timeSinceLevelLoad - timeOfActivation) / timeToIncreaseSpawns)
	var numberOfOne: int = roundi(numberToSpawn * enemySpawnRatio)
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
