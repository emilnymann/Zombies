extends CanvasLayer

onready var settings_popup = $SettingsPopup
onready var fullscreen_toggle = $SettingsPopup/SettingsContainer/FullscreenContainer/FullscreenCheckButton

func _ready():
	fullscreen_toggle.pressed = OS.window_fullscreen

func _on_SettingsButton_pressed():
	settings_popup.popup_centered_minsize(Vector2(450, 200))
