extends Control

signal startDraft
var isDrafting: bool = false
var isPlacingBeacon: bool = false
var draftButtons: Array[Node]
@export var buttonOnePosition: Button
@export var buttonTwoPosition: Button

#this needs to hide all the buttons if a player is currently placing a beacon

func _ready() -> void:
	draftButtons = get_tree().get_nodes_in_group("beacon_button")
	for button in draftButtons:
		button.pressed.connect(HideBeaconButtons)
		button.pressed.connect(SetIsPlacingBeacon.bind(true))
	HideBeaconButtons()

func ToggleDraftButton(numberOfCharges: int):
	#this is now being called on towerPlaced but unfortunately is always hidden?
	#maybe it's being called before isPlacingBeacon is set to false?
	if numberOfCharges <= 0 or isDrafting or isPlacingBeacon:
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

func SetIsPlacingBeacon(isPlacing: bool):
	isPlacingBeacon = isPlacing
	ToggleDraftButton(%ChargeBar.numberOfCharges)

func _on_draft_button_pressed() -> void:
	startDraft.emit()
	isDrafting = true
	ChooseBeaconsToDraft()
	ShowBeaconButtons()

func ChooseBeaconsToDraft():
	var draftPool: Array[Node] = get_tree().get_nodes_in_group("beacon_button")
	var beaconOne: int = randi_range(0, (draftPool.size() - 1))
	draftPool.remove_at(beaconOne)
	var beaconTwo: int = randi_range(0, (draftPool.size() - 1))
	print(draftButtons[beaconOne].name)
	print(draftButtons[beaconTwo].name)
