extends Control

#@export var towerManager: Node2D
#dont do it this way reference the proto tower in tower manager instead
var isMouseOverButton: bool = false

#use enums and match to feed tower type into other scripts

func _process(delta: float) -> void:
	pass

#func BuildTower():
	#print("build le towr")
	#buildingTower = true
	#ghostTower.visible = true
#
#func PlaceTower(position: Vector2):
	#print(mousePosition)
	#ghostTower.visible = false
	#towerManager.PlaceNewTower()
	#buildingTower = false

func _on_button_mouse_entered() -> void:
	isMouseOverButton = true

func _on_button_mouse_exited() -> void:
	isMouseOverButton = false
