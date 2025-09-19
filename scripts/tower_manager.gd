extends Node2D

@export var protoTower: PackedScene
@export var buildUI: Control

var ghostProtoTower: Sprite2D

#new refactor is combining these scripts, here are some variables from other script
var placingTower: bool = false
var isMouseOverButton: bool = false
var mousePosition: Vector2

func _ready() -> void:
	ghostProtoTower = buildUI.find_child("GhostProtoTower")
	#this needs to connect the button pressed signal to SpawnTower

func _process(delta: float) -> void:
	mousePosition = get_global_mouse_position()
	if ghostProtoTower != null:
		ghostProtoTower.position = mousePosition
	if Input.is_action_just_pressed("Multi Action") and buildUI.isMouseOverButton == false:
		if placingTower:
			#PlaceTower(mousePosition)
			pass

func SpawnTower():
	print("spawning new tower to place")
	placingTower = true
	ghostProtoTower.visible = true

func PlaceSpawnedTower():
	var newTower = protoTower.instantiate()
	add_child(newTower)
	newTower.position = mousePosition

	
