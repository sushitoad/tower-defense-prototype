extends Control

signal startDraft
var isDrafting: bool = false
var draftButtons: Array[Node]

#this needs to hide all the buttons if a player is currently placing a beacon

func _ready() -> void:
	draftButtons = get_tree().get_nodes_in_group("beacon_button")
	for button in draftButtons:
		button.pressed.connect(HideBeaconButtons)
	HideBeaconButtons()

func ToggleDraftButton(numberOfCharges: int):
	if numberOfCharges <= 0 or isDrafting:
		$DraftButton.visible = false
	else:
		$DraftButton.visible = true

func ShowBeaconButtons():
	for button in draftButtons:
		button.visible = true
	$DraftButton.visible = false

func HideBeaconButtons():
	for button in draftButtons:
		button.visible = false
	isDrafting = false
	ToggleDraftButton(%ChargeBar.numberOfCharges)

func _on_draft_button_pressed() -> void:
	startDraft.emit()
	isDrafting = true
	ShowBeaconButtons()
