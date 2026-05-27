extends Area2D

#reference to the node that it will show/hide
@export var displayNode: Array[CanvasItem]

func _on_mouse_entered() -> void:
	for node in displayNode:
		node.visible = true

func _on_mouse_exited() -> void:
	for node in displayNode:
		node.visible = false
