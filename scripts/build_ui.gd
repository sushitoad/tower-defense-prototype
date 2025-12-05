extends Control

var isMouseOverButton: bool = false
@export var timeToFullCharge: float = 10
@export var chargeMaxNumber: int = 5
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
		$CanvasLayer/DraftButtonManager.HideDraftButtons()
		print("Toggle tower buttons off")
	else:
		$CanvasLayer/DraftButtonManager.ShowDraftButtons()
		print("Toggle tower buttons on")

func _on_charge_bar_charge_amount_changed() -> void:
	for iconIndex in chargeIcons.size():
		if ($CanvasLayer/ChargeBar.numberOfCharges - 1) >= iconIndex:
			chargeIcons[iconIndex].visible = true
		else:
			chargeIcons[iconIndex].visible = false

func ShowHideBasicTowerTooltip():
	$CanvasLayer/DraftButtonManager/BasicTowerButton/BasicTowerTooltip.visible = !$CanvasLayer/DraftButtonManager/BasicTowerButton/BasicTowerTooltip.visible

func ShowHideChargeTowerTooltip():
	$CanvasLayer/DraftButtonManager/ChargeTowerButton/ChargeTowerTooltip.visible = !$CanvasLayer/DraftButtonManager/ChargeTowerButton/ChargeTowerTooltip.visible
