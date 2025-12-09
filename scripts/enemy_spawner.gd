extends Node2D

@export var enemyTypeOne: PackedScene
@export var enemyTypeTwo: PackedScene
@export var spawnNumberBase: int = 1
@export var enemySpawnRatio: float = 0.5
@export var timeBetweenSpawns: float = 10
@export var timeToIncreaseSpawns: float = 30
@export var spawnDelay: float = 0.3
@export var activatesLater: bool = false
@export var timeToActivate: float = 120
var activated: bool = false
var timeThisWasActivated: float
var timeManager: Node
var beaconManager: Node2D

func _ready() -> void:
	$SpawnTimer.wait_time = timeBetweenSpawns
	timeManager = get_node("%TimeManager")
	beaconManager = get_node("%BeaconManager")
	if activatesLater:
		$SpawnTimer.stop()
		$Sprite2D.visible = false
		activated = false
	else:
		activated = true
		timeThisWasActivated = timeManager.timeSinceLevelLoad

func _process(delta: float) -> void:
	if activatesLater:
		if !activated:
			if timeManager.timeSinceLevelLoad >= timeToActivate:
				$SpawnTimer.start()
				$Sprite2D.visible = true
				activated = true
				timeThisWasActivated = timeManager.timeSinceLevelLoad
				print(self.name + " activated")

func _on_spawn_timer_timeout() -> void:
	SpawnAllEnemies()
	
func SpawnAllEnemies():
	var numberToSpawn = spawnNumberBase + roundi((timeManager.timeSinceLevelLoad - timeThisWasActivated) / timeToIncreaseSpawns)
	var numberOfOne: int = roundi(numberToSpawn * enemySpawnRatio)
	var numberOfTwo: int = numberToSpawn - numberOfOne
	SpawnEnemyType(numberOfOne, enemyTypeOne)
	SpawnEnemyType(numberOfTwo, enemyTypeTwo)

func SpawnEnemyType(amount: int, type: PackedScene):
	for num in amount:
		var newEnemy
		newEnemy = type.instantiate()
		add_child(newEnemy)
		beaconManager.beaconPlaced.connect(newEnemy.FindTarget)
		newEnemy.global_position = global_position
		await get_tree().create_timer(spawnDelay).timeout
