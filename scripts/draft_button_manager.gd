extends Control

@export var draftButtons: Array[Button]

func ShowDraftButtons():
	for button in draftButtons:
		button.visible = true

func HideDraftButtons():
	for button in draftButtons:
		button.visible = false
