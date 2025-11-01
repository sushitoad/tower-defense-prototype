extends Node2D

@export var basicTower: PackedScene
@export var chargeTower: PackedScene
@export var buildUI: Control

var ghostTower: Sprite2D

var placingTower: bool = false
var mousePosition: Vector2

enum TowerType { BASIC, CHARGE, HEARTFIRE }
var towerTypeToPlace: TowerType

func _ready() -> void:
	#for button in buildUI.find_children("*", "Button"):
		#button.pressed.connect(SpawnTower)
	var basicButtion = buildUI.find_child("BasicTowerButton")
	basicButtion.pressed.connect(SpawnTower.bind(TowerType.BASIC))
	var chargeButtion = buildUI.find_child("ChargeTowerButton")
	chargeButtion.pressed.connect(SpawnTower.bind(TowerType.CHARGE))

func _process(delta: float) -> void:
	mousePosition = get_global_mouse_position()
	if ghostTower != null:
		ghostTower.position = mousePosition
	if Input.is_action_just_pressed("LeftClick") and buildUI.isMouseOverButton == false:
		if placingTower:
			PlaceSpawnedTower()

func SpawnTower(type: TowerType):
	placingTower = true
	match type:
		0:
			ghostTower = find_child("BasicTowerSprite")
		1:
			ghostTower = find_child("ChargeTowerSprite")
		_:
			print("other")
	towerTypeToPlace = type
	ghostTower.visible = true

func PlaceSpawnedTower():
	ghostTower.visible = false
	var newTower
	match towerTypeToPlace:
		0:
			newTower = basicTower.instantiate()
		1:
			newTower = chargeTower.instantiate()
	add_child(newTower)
	newTower.position = mousePosition
	placingTower = false
