extends Area2D

@export var chargeBoostPercent: float = 5
@export var enemySlowAmount: float = 4
var buildUI: Control
var chargeBar: ProgressBar
@onready var tower: StaticBody2D = get_parent()
#while this is not dormant or being placed, adds to a value in the charge bar called charge reduction
#slows enemies that enter the area 2d
var slowedEnemies: Array[CharacterBody2D]

func _ready() -> void:
	var UIelements = get_tree().get_nodes_in_group("UI")
	for element in UIelements:
		if element is Control:
			if element.name == "BuildUI":
				buildUI = element
	chargeBar = buildUI.find_child("ChargeBar")
	tower.on_destroyed.connect(AdjustChargeRate)
	tower.on_awoke.connect(AdjustChargeRate)
	if !tower.isDestroyed and !tower.isBeingPlaced:
		AdjustChargeRate()

#in process, if not destroyed, find each enemy in range and apply slow
#how does is not add an additional charge each frame?

func AdjustChargeRate():
	if !tower.isDestroyed and !tower.isBeingPlaced:
		chargeBar.chargeTowerBoost += (chargeBoostPercent / 100)
	else:
		chargeBar.chargeTowerBoost -= (chargeBoostPercent / 100)
	print("charge rate is: " + str(chargeBar.chargeTowerBoost))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		SlowEnemy(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		UnslowEnemy(body)

func StopSlowOnDormant():
	#this will be connected to the on_destroyed signal
	var circleShape: Shape2D = $RangeShape2D.shape
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) < circleShape.radius:
			UnslowEnemy(enemy)

func StartSlowOnAwoke():
	#this will be connected to the on_awoke signal
	var circleShape: Shape2D = $RangeShape2D.shape
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) < circleShape.radius:
			SlowEnemy(enemy)

#not sure this is working now, test more
func SlowEnemy(enemy: CharacterBody2D):
	enemy.speedReduction += enemySlowAmount
	#slowedEnemies.append(enemy)

func UnslowEnemy(enemy: CharacterBody2D):
	enemy.speedReduction -= enemySlowAmount
	#slowedEnemies.remove_at(slowedEnemies.find(enemy))
