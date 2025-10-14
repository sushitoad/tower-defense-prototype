extends StaticBody2D

@export var maxHealth: int = 100
@export var allure: float = 10
var currentHealth: int

func _ready() -> void:
	currentHealth = maxHealth
	TakeDamage(0)
	
func TakeDamage(damage: int):
	currentHealth -= damage
	print(currentHealth)
