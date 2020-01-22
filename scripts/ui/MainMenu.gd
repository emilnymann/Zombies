extends CanvasLayer

onready var fullscreen_toggle = $OptionsMenuControl/MenuContainer/OptionsContainer/FullscreenContainer/FullscreenCheckbox
onready var master_volume_slider = $OptionsMenuControl/MenuContainer/OptionsContainer/MasterVolumeContainer/MasterVolumeSliderContainer/MasterVolumeSlider

export var volume_range_min_db = -20
var fullscreen : bool
var master_volume : float

func _ready():
	var master_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	
	fullscreen = OS.window_fullscreen
	master_volume = ( master_volume_db / volume_range_min_db ) * -100
	print(master_volume)
	
	fullscreen_toggle.pressed = fullscreen
	master_volume_slider.value = master_volume



func _on_Options_SaveButton_pressed():
	var master_volume_percent = abs(master_volume_slider.value)
	
	fullscreen = fullscreen_toggle.pressed
	master_volume = (master_volume_percent / 100) * volume_range_min_db
	
	OS.window_fullscreen = fullscreen
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume)
