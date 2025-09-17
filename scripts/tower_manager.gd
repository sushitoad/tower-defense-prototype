extends Node2D

@export var protoTower: PackedScene

#new refactor is combining these scripts, here are some variables from other script
var placingingTower: bool = false
var isMouseOverButton: bool = false
var mousePosition: Vector2

func _process(delta: float) -> void:
	mousePosition = get_global_mouse_position()
	#if ghostTower != null:
		#ghostTower.position = mousePosition
	if Input.is_action_just_pressed("Multi Action") and isMouseOverButton == false:
		if placingingTower:
			#PlaceTower(mousePosition)
			pass

func SpawnTower():
	print("spawning new tower to place")
	placingingTower = true
	#ghostTower.visible = true

func PlaceNewTower():
	var newTower = protoTower.instantiate()
	add_child(newTower)
	newTower.position = get_global_mouse_position()

	
