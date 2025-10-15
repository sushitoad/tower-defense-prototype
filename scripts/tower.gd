extends StaticBody2D

@export var maxHealth: int = 100
@export var allure: float = 10
var currentHealth: int
var isDestroyed: bool = false

signal on_destroyed

func _ready() -> void:
	currentHealth = maxHealth
	isDestroyed = false
	
func TakeDamage(damage: int):
	currentHealth -= damage
	print(currentHealth)
	if currentHealth <= 0:
		isDestroyed = true
		on_destroyed.emit()
		call_deferred("queue_free")
