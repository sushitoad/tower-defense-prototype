extends Node

signal victoryTimeReached
var pastVictoryTime: bool = false
var timeSinceLevelLoad: float = 0
@export var timeToVictory: float

func _ready() -> void:
	timeSinceLevelLoad = 0

func _process(delta: float) -> void:
	timeSinceLevelLoad += delta
	if !pastVictoryTime:
		if timeSinceLevelLoad >= timeToVictory:
			victoryTimeReached.emit()
			pastVictoryTime = true
