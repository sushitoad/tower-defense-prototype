extends Area2D

@export var defaultEnemySlowAmount: float = 20
var totalEnemySlowAmount: float
@export var nearbyBeaconSlowRangeBonus: float = 10
@onready var beacon: StaticBody2D = get_parent()
@onready var circleShape: Shape2D = $RangeShape2D.shape
@onready var circleStartingRadius: float = circleShape.radius
var enemiesInRangeToSlow: Array[CharacterBody2D]
var slowedEnemies: Array[CharacterBody2D]
var nearbyBeacons: Array[StaticBody2D]

func _ready() -> void:
	beacon.on_destroyed.connect(StopSlowOnDormant)
	beacon.on_awoke.connect(StartSlowOnAwoke)
	totalEnemySlowAmount = defaultEnemySlowAmount

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
	enemy.speedReduction += defaultEnemySlowAmount

func UnslowEnemy(enemy: CharacterBody2D):
	slowedEnemies.remove_at(slowedEnemies.find(enemy))
	enemy.speedReduction -= defaultEnemySlowAmount

#why does this not happen when beacon is placed?
#can I comb through this and make sure the basic behaviors are happening as intended?
func SetSlowRange():
	var uniqueBeacons: Array[StaticBody2D]
	var otherSunBeaconCounter: int = 0
	#print(nearbyBeacons)
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
	#print(uniqueBeacons)
	#print(otherSunBeaconCounter)
	circleShape.radius = circleStartingRadius + (uniqueBeacons.size() * nearbyBeaconSlowRangeBonus)
	circleShape.radius = circleShape.radius - (otherSunBeaconCounter * nearbyBeaconSlowRangeBonus)
	#print(circleShape.radius)
	#im not updating the rangesprite and I honestly have no idea how I'd do that

#this isn't running at all after the beacon is placed... whyyyyy?!
func _on_nearby_beacons_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		print("nearby beacon: " + str(body.name))

func _on_nearby_beacons_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		print("bye bye " + str(body.name))
