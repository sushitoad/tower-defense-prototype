extends Control

@export var towerManager: Node2D
@onready var ghostTower: Sprite2D = $CanvasLayer/GhostSprite
#dont do it this way reference the proto tower in tower manager instead
var buildingTower: bool = false
var isMouseOverButton: bool = false
var mousePosition: Vector2

#use enums and match to feed tower type into other scripts

func _process(delta: float) -> void:
	mousePosition = get_global_mouse_position()
	if ghostTower != null:
		ghostTower.position = mousePosition
	if Input.is_action_just_pressed("Multi Action") and isMouseOverButton == false:
		if buildingTower:
			PlaceTower(mousePosition)

func BuildTower():
	print("build le towr")
	buildingTower = true
	ghostTower.visible = true

func PlaceTower(position: Vector2):
	print(mousePosition)
	ghostTower.visible = false
	towerManager.PlaceNewTower()
	buildingTower = false

func _on_button_mouse_entered() -> void:
	isMouseOverButton = true

func _on_button_mouse_exited() -> void:
	isMouseOverButton = false
