extends Control

var isMouseOverButton: bool = false
@export var chargeIcons: Array[TextureRect]

func _ready() -> void:
	ToggleTowerButtons()
	_on_charge_bar_charge_amount_changed()

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

func _on_charge_bar_charge_amount_changed() -> void:
	for iconIndex in chargeIcons.size():
		if ($CanvasLayer/ChargeBar.numberOfCharges - 1) >= iconIndex:
			chargeIcons[iconIndex].visible = true
		else:
			chargeIcons[iconIndex].visible = false
		
