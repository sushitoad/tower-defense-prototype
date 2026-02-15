extends Node2D

signal beaconPlaced

@export var basicTower: PackedScene
@export var chargeTower: PackedScene
@export var lightburnBeacon: PackedScene
@export var sunBeacon: PackedScene
@export var buildUI: Control

var placingBeacon: bool = false
var mousePosition: Vector2

var beaconTypeToPlace: GlobalEnums.BeaconType
var newBeacon: StaticBody2D

func _ready() -> void:
	var basicButtion = buildUI.find_child("BasicTowerButton")
	basicButtion.pressed.connect(SpawnBeacon.bind(GlobalEnums.BeaconType.BASIC))
	var chargeButtion = buildUI.find_child("ChargeTowerButton")
	chargeButtion.pressed.connect(SpawnBeacon.bind(GlobalEnums.BeaconType.CHARGE))
	var lightburnButton = buildUI.find_child("LightburnBeaconButton")
	lightburnButton.pressed.connect(SpawnBeacon.bind(GlobalEnums.BeaconType.LIGHTBURN))
	var sunButton = buildUI.find_child("SunBeaconButton")
	sunButton.pressed.connect(SpawnBeacon.bind(GlobalEnums.BeaconType.SUN))

func _process(delta: float) -> void:
	mousePosition = get_global_mouse_position()
	if newBeacon != null:
		newBeacon.position = mousePosition
	if Input.is_action_just_pressed("LeftClick") and buildUI.isMouseOverButton == false:
		if placingBeacon:
			if newBeacon.isBeingPlaced and !newBeacon.tooCloseToOthers:
				PlaceSpawnedBeacon()

func SpawnBeacon(type: GlobalEnums.BeaconType):
	placingBeacon = true
	match type:
		0:
			newBeacon = basicTower.instantiate()
		1:
			newBeacon = chargeTower.instantiate()
		3:
			newBeacon = lightburnBeacon.instantiate()
		5:
			newBeacon = sunBeacon.instantiate()
		_:
			print("error- BeaconType")
	add_child(newBeacon)
	newBeacon.isBeingPlaced = true
	newBeacon.get_node("CollisionShape2D").disabled = true
	newBeacon.find_child("RangeSprite2D").visible = true

func PlaceSpawnedBeacon():
	beaconPlaced.emit()
	newBeacon.on_placed.emit()
	#newBeacon.WakeThisBeacon()
	#newBeacon.get_node("CollisionShape2D").disabled = false
	newBeacon.find_child("RangeSprite2D").visible = false
	newBeacon.isBeingPlaced = false
	newBeacon = null
	placingBeacon = false
