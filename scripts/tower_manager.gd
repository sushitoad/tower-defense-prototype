extends Node2D

signal towerPlaced

@export var basicTower: PackedScene
@export var chargeTower: PackedScene
@export var buildUI: Control

#var ghostTower: Sprite2D

#var placingTower: bool = false
var mousePosition: Vector2

enum TowerType { BASIC, CHARGE, HEARTFIRE }
var towerTypeToPlace: TowerType
var newTower: StaticBody2D

func _ready() -> void:
	#for button in buildUI.find_children("*", "Button"):
		#button.pressed.connect(SpawnTower)
	var basicButtion = buildUI.find_child("BasicTowerButton")
	basicButtion.pressed.connect(SpawnTower.bind(TowerType.BASIC))
	var chargeButtion = buildUI.find_child("ChargeTowerButton")
	chargeButtion.pressed.connect(SpawnTower.bind(TowerType.CHARGE))

func _process(delta: float) -> void:
	mousePosition = get_global_mouse_position()
	if newTower != null:
		newTower.position = mousePosition
	if Input.is_action_just_pressed("LeftClick") and buildUI.isMouseOverButton == false:
		if newTower.isBeingPlaced and !newTower.tooCloseToOthers:
			PlaceSpawnedTower()

func SpawnTower(type: TowerType):
	match type:
		0:
			newTower = basicTower.instantiate()
		1:
			newTower = chargeTower.instantiate()
		_:
			print("error- TowerType mismatch")
	add_child(newTower)
	newTower.isBeingPlaced = true
	newTower.get_node("CollisionShape2D").disabled = true

func PlaceSpawnedTower():
	newTower.isBeingPlaced = false
	towerPlaced.emit()
	newTower.get_node("CollisionShape2D").disabled = false
	newTower = null
