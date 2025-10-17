extends StaticBody2D

@export var maxHealth: int = 100
@export var allure: float = 10
@export var dormantTime: float = 10
@export var dormantColor: Color = Color(1, 1, 1, 0.5)
var currentHealth: int
var isDestroyed: bool = false

signal on_destroyed

func _ready() -> void:
	currentHealth = maxHealth
	isDestroyed = false
	$DormantTimer.timeout.connect(WakeThisTower)
	
func TakeDamage(damage: int):
	currentHealth -= damage
	print(currentHealth)
	if currentHealth <= 0:
		isDestroyed = true
		on_destroyed.emit()
		$DormantTimer.start(dormantTime)
		$Sprite2D.modulate = dormantColor

func WakeThisTower():
	isDestroyed = false
	currentHealth = maxHealth
	$Sprite2D.modulate = Color(1, 1, 1, 1)
