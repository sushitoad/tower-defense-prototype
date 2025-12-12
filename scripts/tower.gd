extends StaticBody2D

enum BeaconType { BASIC, CHARGE, HEARTFIRE, LIGHTBURN }
signal on_destroyed
signal on_awoke

@export var maxHealth: int = 100
@export var allure: float = 10
@export var dormantTime: float = 10
@export var dormantColor: Color = Color(1, 1, 1, 0.5)
@export var distanceNeededToPlace: float = 40
@export var beaconType: BeaconType
var currentHealth: int
var baseColor: Color
var isDestroyed: bool = false
var isBeingPlaced: bool = false
var tooCloseToOthers: bool = false

func _ready() -> void:
	baseColor = $Sprite2D.modulate
	currentHealth = maxHealth
	isDestroyed = false
	if beaconType != BeaconType.HEARTFIRE:
		$DormantTimer.timeout.connect(WakeThisBeacon)

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
			$Sprite2D.modulate = Color(1, 1, 1, 1)

func TakeDamage(damage: int):
	currentHealth -= damage
	if currentHealth <= 0:
		currentHealth = 0
		isDestroyed = true
		$CollisionShape2D.disabled = true
		on_destroyed.emit()
		if beaconType != BeaconType.HEARTFIRE:
			$DormantTimer.start(dormantTime)
			$Sprite2D.modulate = dormantColor
		else:
			get_node("%LevelManager").GameEnd(false)

func WakeThisBeacon():
	isDestroyed = false
	$CollisionShape2D.disabled = false
	on_awoke.emit()
	currentHealth = maxHealth
	$Sprite2D.modulate = baseColor
