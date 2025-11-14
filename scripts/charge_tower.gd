extends Area2D

@export var chargeBoostPercent: float = 5
var buildUI: Control
var chargeBar: ProgressBar
@onready var tower: StaticBody2D = get_parent()
#while this is not dormant or being placed, adds to a value in the charge bar called charge reduction
#slows enemies that enter the area 2d

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

func AdjustChargeRate():
	if !tower.isDestroyed and !tower.isBeingPlaced:
		chargeBar.chargeTowerBoost += (chargeBoostPercent / 100)
	else:
		chargeBar.chargeTowerBoost -= (chargeBoostPercent / 100)
	print("charge rate is: " + str(chargeBar.chargeTowerBoost))
