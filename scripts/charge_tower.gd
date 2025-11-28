extends Area2D

@export var chargeBoostPercent: float = 5
@export var enemySlowAmount: float = 15
@export var startsOnMap: bool = false
var buildUI: Control
var chargeBar: ProgressBar
@onready var tower: StaticBody2D = get_parent()
@onready 	var circleShape: Shape2D = $RangeShape2D.shape
#while this is not dormant or being placed, adds to a value in the charge bar called charge reduction
#slows enemies that enter the area 2d
var enemiesInRangeToSlow: Array[CharacterBody2D]
var slowedEnemies: Array[CharacterBody2D]

func _ready() -> void:
	var UIelements = get_tree().get_nodes_in_group("UI")
	for element in UIelements:
		if element is Control:
			if element.name == "BuildUI":
				buildUI = element
	chargeBar = buildUI.find_child("ChargeBar")
	tower.on_destroyed.connect(AdjustChargeRate)
	tower.on_destroyed.connect(StopSlowOnDormant)
	tower.on_awoke.connect(AdjustChargeRate)
	tower.on_awoke.connect(StartSlowOnAwoke)
	if Time.get_ticks_msec() < 2000:
		AdjustChargeRate()

func AdjustChargeRate():
	if !tower.isDestroyed:
		chargeBar.chargeTowerBoost += (chargeBoostPercent / 100)
	else:
		chargeBar.chargeTowerBoost -= (chargeBoostPercent / 100)
	print("charge rate is: " + str(chargeBar.chargeTowerBoost))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRangeToSlow.append(body)
		if !tower.isDestroyed and !tower.isBeingPlaced:
			SlowEnemy(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRangeToSlow.remove_at(enemiesInRangeToSlow.find(body))
		if slowedEnemies.find(body) != -1:
			UnslowEnemy(body)

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
