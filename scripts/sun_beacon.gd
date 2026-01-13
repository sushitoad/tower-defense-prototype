extends Area2D

@export var enemySlowAmount: float = 20
@export var nearbyBeaconSlowRangeBonus: float = 10
@onready var beacon: StaticBody2D = get_parent()
@onready var circleShape: Shape2D = $RangeShape2D.shape
var enemiesInRangeToSlow: Array[CharacterBody2D]
var slowedEnemies: Array[CharacterBody2D]
var nearbyBeacons: Array[StaticBody2D]

func _ready() -> void:
	beacon.on_destroyed.connect(StopSlowOnDormant)
	beacon.on_awoke.connect(StartSlowOnAwoke)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRangeToSlow.append(body)
		if !beacon.isDestroyed and !beacon.isBeingPlaced:
			SlowEnemy(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRangeToSlow.remove_at(enemiesInRangeToSlow.find(body))
		if slowedEnemies.find(body) != -1:
			UnslowEnemy(body)

func StopSlowOnDormant():
	SetSlowRange()
	for enemy in slowedEnemies:
		UnslowEnemy(enemy)

func StartSlowOnAwoke():
	SetSlowRange()
	for enemy in enemiesInRangeToSlow:
		if slowedEnemies.find(enemy) == -1:
			SlowEnemy(enemy)

func SlowEnemy(enemy: CharacterBody2D):
	slowedEnemies.append(enemy)
	enemy.speedReduction += enemySlowAmount

func UnslowEnemy(enemy: CharacterBody2D):
	slowedEnemies.remove_at(slowedEnemies.find(enemy))
	enemy.speedReduction -= enemySlowAmount

func SetSlowRange():
	var uniqueBeacons: Array[StaticBody2D]
	var otherSunBeaconCounter: int = 0
	for beacon in nearbyBeacons:
		var type: GlobalEnums.BeaconType = beacon.beaconType
		var isUnique: bool = false
		if type == GlobalEnums.BeaconType.SUN:
			otherSunBeaconCounter += 1
		elif type != GlobalEnums.BeaconType.SUN:
			isUnique = true
			for unit in uniqueBeacons:
				if type == unit.beaconType:
					isUnique = false
		if isUnique:
			uniqueBeacons.append(beacon)
	print(uniqueBeacons)
	print(otherSunBeaconCounter)
	#range += unique beacon array.size() + nearbyBeaconSlowRangeBonus
	#range -= otherSunBeaconCounter * nearbyBeaconSlowRangeBonus

func _on_nearby_beacons_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		nearbyBeacons.append(body)
	SetSlowRange()

func _on_nearby_beacons_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		nearbyBeacons.remove_at(nearbyBeacons.find(body))
	SetSlowRange()
