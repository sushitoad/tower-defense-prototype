extends Control

signal startDraft
var isDrafting: bool = false
var isPlacingBeacon: bool = false
var draftButtons: Array[Node]
var currentBeaconButtonSet: Array[Button]
@export var numberOfBeaconsToDraft: int = 2
@export var draftedButtonPositons: Array[Control]

func _ready() -> void:
	draftButtons = get_tree().get_nodes_in_group("beacon_button")
	draftedButtonPositons.resize(numberOfBeaconsToDraft)
	for button in draftButtons:
		button.pressed.connect(HideBeaconButtons)
		button.pressed.connect(SetIsPlacingBeacon.bind(true))
	HideBeaconButtons()

func ToggleDraftButton(numberOfCharges: int):
	if numberOfCharges <= 0 or isDrafting or isPlacingBeacon:
		$DraftButton.visible = false
	else:
		$DraftButton.visible = true

func ShowBeaconButtons():
	var count: int = 0
	for button in currentBeaconButtonSet:
		button.position = draftedButtonPositons[count].position
		button.visible = true
		count += 1
		#this part isn't working, check the formatting of the ui elements and see if
		#the same thing happens when they're way more spread out
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
	var currentDraft: Array[Node] = draftButtons.duplicate()
	currentDraft.shuffle()
	currentDraft.resize(numberOfBeaconsToDraft)
	var buttonsToShow: Array[Button]
	for beacon in currentDraft:
		var button: Button = find_child(beacon.name)
		buttonsToShow.append(button)
	currentBeaconButtonSet = buttonsToShow.duplicate(true)
	print(currentBeaconButtonSet)
		#so what if there was an array of buttons that was empty, but this populated them
		#and then show beacon buttons 

	#find the two buttons in draftButtons that correspond with the two picks in currentDraft
	#set each position to the stored positions
