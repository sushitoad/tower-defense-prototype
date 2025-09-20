extends Node2D

@export var protoTower: PackedScene
@export var buildUI: Control

var ghostProtoTower: Sprite2D

var placingTower: bool = false
var mousePosition: Vector2

func _ready() -> void:
	ghostProtoTower = buildUI.find_child("GhostProtoTower")
	var buildButton = buildUI.find_child("Button")
	#I will need a different solution when I have more tower options and more buttons
	buildButton.pressed.connect(SpawnTower)

func _process(delta: float) -> void:
	mousePosition = get_global_mouse_position()
	if ghostProtoTower != null:
		ghostProtoTower.position = mousePosition
	if Input.is_action_just_pressed("LeftClick") and buildUI.isMouseOverButton == false:
		if placingTower:
			PlaceSpawnedTower()

func SpawnTower():
	placingTower = true
	ghostProtoTower.visible = true

func PlaceSpawnedTower():
	ghostProtoTower.visible = false
	var newTower = protoTower.instantiate()
	add_child(newTower)
	newTower.position = mousePosition
	placingTower = false
