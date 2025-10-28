extends Node

var timeSinceLevelLoad: float = 0

func _ready() -> void:
	timeSinceLevelLoad = 0

func _process(delta: float) -> void:
	timeSinceLevelLoad += delta

func GameOver():
	get_tree().reload_current_scene()
