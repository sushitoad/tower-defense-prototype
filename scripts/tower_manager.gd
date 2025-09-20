extends Node2D

@export var basicTower: PackedScene
@export var chargeTower: PackedScene
@export var buildUI: Control

var ghostTower: Sprite2D

var placingTower: bool = false
var mousePosition: Vector2

#its enum and match time

func _ready() -> void:
	for button in buildUI.find_children("*", "Button"):
		button.pressed.connect(SpawnTower)
	#this is clever but I might have to write an individual line for each button and have specific functions per tower?

func _process(delta: float) -> void:
	mousePosition = get_global_mouse_position()
	if ghostTower != null:
		ghostTower.position = mousePosition
	if Input.is_action_just_pressed("LeftClick") and buildUI.isMouseOverButton == false:
		if placingTower:
			PlaceSpawnedTower()

func SpawnTower():
	placingTower = true
	ghostTower = find_child("BasicTowerSprite")
	ghostTower.visible = true

func PlaceSpawnedTower():
	ghostTower.visible = false
	var newTower = basicTower.instantiate()
	add_child(newTower)
	newTower.position = mousePosition
	placingTower = false
