extends Control

signal isPaused
signal isUnpaused
@export var gameSceneToLoad: PackedScene
@export var isPauseMenu: bool = false
var mainMenuScene: String = "res://scenes/title_scene.tscn"

#this is set up so that if the menu is used for a pause menu
#the level manager needs to instantiate a pause menu scene each time the game is paused
#and set the "isPaused" bool to true. The node will free itself upon resume
func _ready() -> void:
	if isPauseMenu:
		isPaused.emit()
		get_tree().paused = true

func StartNewGame():
	FreePauseMenu()
	if gameSceneToLoad != null and !isPauseMenu:
		get_tree().change_scene_to_packed(gameSceneToLoad)
	#this functionality for pause menus is a little suspect
	elif isPauseMenu:
		get_tree().reload_current_scene()
	else:
		print("Pick a game scene and add it to the gameSceneToLoad var in the menu script!")

func LoadMainMenu():
	FreePauseMenu()
	if mainMenuScene != null:
		get_tree().change_scene_to_file(mainMenuScene)
	else:
		print("Unable to find main menu scene. Update the file path reference?")

func ResumeGame():
	isUnpaused.emit()
	FreePauseMenu()

func OpenSettings():
	print("I'm jusd a widdle seddings buddon")

func ExitGame():
	FreePauseMenu()
	get_tree().quit()

func FreePauseMenu():
	get_tree().paused = false
	if isPauseMenu:
		queue_free()
