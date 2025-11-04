extends Control

var isMouseOverButton: bool = false

func _ready() -> void:
	ToggleTowerButtons()

func _on_button_mouse_entered() -> void:
	isMouseOverButton = true

func _on_button_mouse_exited() -> void:
	isMouseOverButton = false

func ToggleTowerButtons():
	if $CanvasLayer/ChargeBar.numberOfCharges <= 0:
		$CanvasLayer/BasicTowerButton.visible = false
		$CanvasLayer/ChargeTowerButton.visible = false
	else:
		$CanvasLayer/BasicTowerButton.visible = true
		$CanvasLayer/ChargeTowerButton.visible = true
