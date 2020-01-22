extends Node2D

onready var main_menu = $MainMenu
onready var loading_screen = load("res://entities/UI/LoadingScreen.tscn")
onready var crosshair = load("res://assets/ui/hud/crosshair.png")
onready var music = $Music/MusicMain
export var level_path : String
export var level_name : String

func _ready():
	main_menu.connect("play_button_pressed", self, "_on_PlayButton_pressed")

func _on_PlayButton_pressed():
	loading_screen = loading_screen.instance()
	loading_screen.connect("continue_pressed", self, "_on_continue_pressed")
	loading_screen.level_to_load = level_path
	loading_screen.level_display_name = level_name
	remove_child(main_menu)
	add_child(loading_screen)
	
func _on_QuitButton_pressed():
	get_tree().quit()
	
func _on_FullscreenCheckButton_toggled(button_pressed):
	OS.window_fullscreen = !OS.window_fullscreen
	
func _on_continue_pressed():
	music.seek(68.0)
	var level = loading_screen.level
	level = level.instance()
	remove_child(loading_screen)
	add_child(level)
	Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_ARROW, Vector2(16, 16))