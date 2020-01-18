extends Node2D

onready var main_menu = $MainMenu
onready var loading_screen = load("res://entities/UI/LoadingScreen.tscn")
export var level_path : String
export var level_name : String

func _ready():
	main_menu.get_node("MenuContainer/ButtonsContainer/PlayButton").connect("pressed", self, "_on_PlayButton_pressed")
	main_menu.get_node("MenuContainer/ButtonsContainer/QuitButton").connect("pressed", self, "_on_QuitButton_pressed")

func _on_PlayButton_pressed():
	remove_child(main_menu)
	loading_screen = loading_screen.instance()
	loading_screen.level_to_load = level_path
	loading_screen.level_display_name = level_name
	add_child(loading_screen)
	
func _on_QuitButton_pressed():
	get_tree().quit()