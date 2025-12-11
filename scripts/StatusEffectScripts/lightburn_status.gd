extends Timer

@export var effectEndCounter: int = 5

@onready var effectEndStartingValue: int = effectEndCounter

func _on_timeout() -> void:
	effectEndCounter -= 1
	if effectEndCounter <= 0:
		queue_free()
