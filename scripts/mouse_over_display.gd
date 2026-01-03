extends Area2D

#reference to the node that it will show/hide
@export var displayNode: CanvasItem

func _on_mouse_entered() -> void:
	displayNode.visible = true

func _on_mouse_exited() -> void:
	displayNode.visible = false
