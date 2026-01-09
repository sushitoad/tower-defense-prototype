extends Area2D

@export var enemySlowAmount: float = 20
@export var nearbyBeaconSlowRangeBonus: float = 10
@onready var tower: StaticBody2D = get_parent()
@onready 	var circleShape: Shape2D = $RangeShape2D.shape
var enemiesInRangeToSlow: Array[CharacterBody2D]
var slowedEnemies: Array[CharacterBody2D]
var nearbyBeacons: Array[StaticBody2D]

func _ready() -> void:
	tower.on_destroyed.connect(StopSlowOnDormant)
	tower.on_awoke.connect(StartSlowOnAwoke)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRangeToSlow.append(body)
		if !tower.isDestroyed and !tower.isBeingPlaced:
			SlowEnemy(body)
	elif body.is_in_group("beacon"):
		print("found a nearby beacon")
		pass #add to nearby beacons

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRangeToSlow.remove_at(enemiesInRangeToSlow.find(body))
		if slowedEnemies.find(body) != -1:
			UnslowEnemy(body)
	elif body.is_in_group("beacon"):
		print("left a nearby beacon")
		pass #remove from nearby beacons

#you probably want a separate area 2d to measure the range of nearby beacons, right now this is going off slow range

func StopSlowOnDormant():
	for enemy in slowedEnemies:
		UnslowEnemy(enemy)

func StartSlowOnAwoke():
	for enemy in enemiesInRangeToSlow:
		if slowedEnemies.find(enemy) == -1:
			SlowEnemy(enemy)

func SlowEnemy(enemy: CharacterBody2D):
	slowedEnemies.append(enemy)
	enemy.speedReduction += enemySlowAmount

func UnslowEnemy(enemy: CharacterBody2D):
	slowedEnemies.remove_at(slowedEnemies.find(enemy))
	enemy.speedReduction -= enemySlowAmount
	
#on body entered

#on body exited

func SetSlowRange():
	pass
	#var unique beacon array
	var otherSunBeaconCounter: int = 0
	for beacon in nearbyBeacons:
		pass
		#var beacon type = beacon.BeaconType
		#if beacon type = BeaconType.SUN, otherSunBeaconCounter += 1
		#if beacon type != the type of all the other beacons in unique beacon array
		#append beacon to unique beacon array
	#range += unique beacon array.size() + nearbyBeaconSlowRangeBonus
	#range -= otherSunBeaconCounter * nearbyBeaconSlowRangeBonus
