extends StaticBody2D

enum TowerType { BASIC, CHARGE, HEARTFIRE, LIGHTBURN }
signal on_destroyed
signal on_awoke

@export var maxHealth: int = 100
@export var allure: float = 10
@export var dormantTime: float = 10
@export var dormantColor: Color = Color(1, 1, 1, 0.5)
@export var distanceNeededToPlace: float = 40
@export var towerType: TowerType
var currentHealth: int
var isDestroyed: bool = false
var isBeingPlaced: bool = false
var tooCloseToOthers: bool = false

func _ready() -> void:
	currentHealth = maxHealth
	isDestroyed = false
	if towerType != TowerType.HEARTFIRE:
		$DormantTimer.timeout.connect(WakeThisTower)

func _process(delta: float) -> void:
	if isBeingPlaced:
		var allOtherTowers = get_tree().get_nodes_in_group("tower")
		allOtherTowers.remove_at(allOtherTowers.find(self))
		var noneTooClose: bool = true
		for tower in allOtherTowers:
			var distanceNeeded: float = distanceNeededToPlace
			if tower.name == "TheHeartfire":
				distanceNeeded = distanceNeededToPlace * 2
			if global_position.distance_to(tower.global_position) < distanceNeeded:
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
		if towerType != TowerType.HEARTFIRE:
			$DormantTimer.start(dormantTime)
			$Sprite2D.modulate = dormantColor
		else:
			get_node("%LevelManager").GameEnd(false)

func WakeThisTower():
	isDestroyed = false
	$CollisionShape2D.disabled = false
	on_awoke.emit()
	currentHealth = maxHealth
	$Sprite2D.modulate = Color(1, 1, 1, 1)
