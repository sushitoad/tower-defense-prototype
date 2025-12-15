extends Timer

signal effect_end
@export var effectEndCounter: int = 5

@onready var effectEndStartingValue: int = effectEndCounter

func _on_timeout() -> void:
	effectEndCounter -= 1
	if effectEndCounter <= 0:
		effect_end.emit()
		queue_free()
