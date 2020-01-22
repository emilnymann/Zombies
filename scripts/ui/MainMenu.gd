extends CanvasLayer

# main
onready var main_menu = $MainMenuControl
onready var options_menu = $OptionsMenuControl

# options
onready var fullscreen_toggle = $OptionsMenuControl/MenuContainer/OptionsContainer/FullscreenContainer/FullscreenCheckbox
onready var master_volume_slider = $OptionsMenuControl/MenuContainer/OptionsContainer/MasterVolumeContainer/MasterVolumeSliderContainer/MasterVolumeSlider
onready var music_volume_slider = $OptionsMenuControl/MenuContainer/OptionsContainer/MusicVolumeContainer/MusicVolumeSliderContainer/MusicVolumeSlider

export var volume_range_min_db = -20
var fullscreen : bool
var master_volume : float
var music_volume : float

# signals
signal play_button_pressed

func _ready():
	var master_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	var music_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	
	fullscreen = OS.window_fullscreen
	master_volume = ( master_volume_db / volume_range_min_db ) * -100
	music_volume = ( music_volume_db / volume_range_min_db ) * -100
	
	fullscreen_toggle.pressed = fullscreen
	master_volume_slider.value = master_volume
	music_volume_slider.value = music_volume



func _on_Options_SaveButton_pressed():
	var master_volume_percent = abs(master_volume_slider.value)
	var music_volume_percent = abs(music_volume_slider.value)
	
	fullscreen = fullscreen_toggle.pressed
	master_volume = (master_volume_percent / 100) * volume_range_min_db
	music_volume = (music_volume_percent / 100) * volume_range_min_db
	
	OS.window_fullscreen = fullscreen
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)


func _on_Options_BackButton_pressed():
	options_menu.visible = false
	main_menu.visible = true

func _on_Main_OptionsButton_pressed():
	main_menu.visible = false
	options_menu.visible = true


func _on_Main_QuitButton_pressed():
	get_tree().quit()


func _on_Main_PlayButton_pressed():
	emit_signal("play_button_pressed")
