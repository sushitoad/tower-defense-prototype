extends Node

var timeSinceLevelLoad: float = 0
var pauseMenuScene: PackedScene = preload("res://scenes/pause_menu.tscn")
var pauseMenu: Control
var gameEndMenuScene: PackedScene = preload("res://scenes/game_end_menu.tscn")
var gameEndMenu: Control

@export var gameOverText: String
@export var victoryText: String

func _ready() -> void:
	timeSinceLevelLoad = 0
	

func _process(delta: float) -> void:
	timeSinceLevelLoad += delta
	if Input.is_action_just_pressed("Escape"):
		if pauseMenu == null:
			PauseGame()
		else:
			UnpauseGame()

func GameEnd(isVictory: bool):
	gameEndMenu = gameEndMenuScene.instantiate()
	add_child(gameEndMenu)
	if isVictory:
		gameEndMenu.find_child("GameEndLabel").text = victoryText
	else:
		gameEndMenu.find_child("GameEndLabel").text = gameOverText

func PauseGame():
	pauseMenu = pauseMenuScene.instantiate()
	add_child(pauseMenu)

func UnpauseGame():
	if pauseMenu != null:
		pauseMenu.ResumeGame()
		print(pauseMenu)
	else:
		get_tree().paused = false
