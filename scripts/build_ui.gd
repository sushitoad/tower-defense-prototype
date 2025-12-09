extends Control

var isMouseOverButton: bool = false
@export var timeToFullCharge: float = 10
@export var chargeMaxNumber: int = 5
@export var chargeIcons: Array[TextureRect]

func _ready() -> void:
	$CanvasLayer/ChargeBar.chargeAmountChanged.connect($CanvasLayer/DraftButtonManager.ToggleDraftButton)
	%BeaconManager.beaconPlaced.connect($CanvasLayer/DraftButtonManager.SetIsPlacingBeacon.bind(false))

func _on_button_mouse_entered() -> void:
	isMouseOverButton = true

func _on_button_mouse_exited() -> void:
	isMouseOverButton = false

func _on_charge_bar_charge_amount_changed(charges: int) -> void:
	for iconIndex in chargeIcons.size():
		if (charges - 1) >= iconIndex:
			chargeIcons[iconIndex].visible = true
		else:
			chargeIcons[iconIndex].visible = false

func ShowHideBasicTowerTooltip():
	var tooltipLabel: Label = $CanvasLayer/DraftButtonManager/BasicTowerButton/BasicTowerTooltip
	tooltipLabel.visible = !tooltipLabel.visible

func ShowHideChargeTowerTooltip():
	var tooltipLabel: Label = $CanvasLayer/DraftButtonManager/ChargeTowerButton/ChargeTowerTooltip
	tooltipLabel.visible = !tooltipLabel.visible
