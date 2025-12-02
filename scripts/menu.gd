extends Control

@export var gameSceneToLoad: PackedScene

func StartNewGame():
	if gameSceneToLoad != null:
		get_tree().change_scene_to_packed(gameSceneToLoad)
	else:
		print("Pick a game scene and add it to the gameSceneToLoad var in the menu script!")

#resume function

#options function

func ExitGame():
	get_tree().quit()
