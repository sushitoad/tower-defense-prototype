extends Control


var isMouseOverButton: bool = false

#use enums and match to feed tower type into other scripts

func _on_button_mouse_entered() -> void:
	isMouseOverButton = true

func _on_button_mouse_exited() -> void:
	isMouseOverButton = false
