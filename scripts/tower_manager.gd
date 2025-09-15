extends Node2D

@export var protoTower: PackedScene

#also refactor so build ui is telling this which tower to place

func PlaceNewTower():
	var newTower = protoTower.instantiate()
	add_child(newTower)
	newTower.position = get_global_mouse_position()

	
