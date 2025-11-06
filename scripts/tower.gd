extends StaticBody2D

enum TowerType { BASIC, CHARGE, HEARTFIRE }
signal on_destroyed

@export var maxHealth: int = 100
@export var allure: float = 10
@export var dormantTime: float = 10
@export var dormantColor: Color = Color(1, 1, 1, 0.5)
@export var towerType: TowerType
var currentHealth: int
var isDestroyed: bool = false

func _ready() -> void:
	currentHealth = maxHealth
	isDestroyed = false
	if towerType != TowerType.HEARTFIRE:
		$DormantTimer.timeout.connect(WakeThisTower)
	
func TakeDamage(damage: int):
	currentHealth -= damage
	#print(currentHealth)
	if currentHealth <= 0:
		currentHealth = 0
		isDestroyed = true
		on_destroyed.emit()
		if towerType != TowerType.HEARTFIRE:
			$DormantTimer.start(dormantTime)
			$Sprite2D.modulate = dormantColor

func WakeThisTower():
	isDestroyed = false
	currentHealth = maxHealth
	$Sprite2D.modulate = Color(1, 1, 1, 1)
