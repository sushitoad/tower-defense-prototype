extends StaticBody2D

signal on_destroyed
signal on_awoke
signal on_placed

@export var maxHealth: int = 100
@export var allure: float = 10
@export var dormantTime: float = 10
@export var dormantColor: Color = Color(1, 1, 1, 0.4)
@export var distanceNeededToPlace: float = 40
@export var beaconType: GlobalEnums.BeaconType
var rangeSprite: Sprite2D
var currentHealth: int
var isDestroyed: bool = false
var isBeingPlaced: bool = false
var tooCloseToOthers: bool = false

@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var baseColor: Color = $Sprite2D.modulate

func _ready() -> void:
	currentHealth = maxHealth
	isDestroyed = false
	if beaconType != GlobalEnums.BeaconType.HEARTFIRE:
		$DormantTimer.timeout.connect(WakeThisBeacon)
	rangeSprite = find_child("RangeSprite2D")

#its like what each beacon needs is data for each beacon that's considered nearby
#and a reference to the line between them? does every nearby beacon need a line to it
#or just the ones that have a relevant mechanical reason?
#let's say relevant mechanical only, so not every beacon needs to know about lines
#and many beacons will care about nearby beacons but not all, to this might be
#on a script to script basis which is fine because copy pasting is real

func _process(delta: float) -> void:
	if isBeingPlaced:
		var allOtherBeacons = get_tree().get_nodes_in_group("beacon")
		allOtherBeacons.remove_at(allOtherBeacons.find(self))
		var noneTooClose: bool = true
		for beacon in allOtherBeacons:
			var distanceNeeded: float = distanceNeededToPlace
			if beacon.name == "TheHeartfire":
				distanceNeeded = distanceNeededToPlace * 2
			if global_position.distance_to(beacon.global_position) < distanceNeeded:
				tooCloseToOthers = true
				$Sprite2D.modulate = dormantColor
				noneTooClose = false
		if noneTooClose:
			tooCloseToOthers = false
			$Sprite2D.modulate = baseColor

func TakeDamage(damage: int):
	currentHealth -= damage
	if currentHealth <= 0:
		currentHealth = 0
		isDestroyed = true
		$CollisionShape2D.disabled = true
		on_destroyed.emit()
		if beaconType != GlobalEnums.BeaconType.HEARTFIRE:
			$DormantTimer.start(dormantTime)
			#probably move this to an animation eventually
			$Sprite2D.modulate = dormantColor
		else:
			#fix this
			get_node("%LevelManager").GameEnd(false)
	else:
		animPlayer.stop()
		animPlayer.play("take_damage")

func WakeThisBeacon():
	isDestroyed = false
	$CollisionShape2D.disabled = false
	on_awoke.emit()
	currentHealth = maxHealth
	#probably move this to an animation eventually
	$Sprite2D.modulate = baseColor
