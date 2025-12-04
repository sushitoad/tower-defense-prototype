extends Node

var timeSinceLevelLoad: float = 0
var pauseMenuScene: PackedScene = preload("res://scenes/pause_menu.tscn")
var pauseMenu: Control

func _ready() -> void:
	timeSinceLevelLoad = 0
	

func _process(delta: float) -> void:
	timeSinceLevelLoad += delta
	if Input.is_action_just_pressed("Escape"):
		if pauseMenu == null:
			PauseGame()
		else:
			UnpauseGame()

func GameOver():
	get_tree().reload_current_scene()

func PauseGame():
	pauseMenu = pauseMenuScene.instantiate()
	add_child(pauseMenu)

func UnpauseGame():
	if pauseMenu != null:
		pauseMenu.ResumeGame()
		print(pauseMenu)
	else:
		get_tree().paused = false
