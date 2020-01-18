extends CanvasLayer

onready var loading_bar = $LoadingVBoxContainer/LoadingBar
onready var loading_label = $LoadingVBoxContainer/LoadingLabel
onready var flash_tween = $FlashTween
onready var flash_tween_2 = $FlashTween2

var loader : ResourceInteractiveLoader
var loaded = false
var completed = false
var ready = false
var level : PackedScene
var level_to_load : String
var level_display_name : String

var resources : = Array()
var total_chunks

signal continue_pressed

func _ready():
	loader = ResourceLoader.load_interactive(level_to_load)
	loading_label.text = "Loading " + level_display_name + "..."

func _process(delta):
	print(loading_label.get("custom_colors/font_color"))
	if ready:
		if !loaded:
			var err = loader.poll()
	
			if err == ERR_FILE_EOF:
				loaded = true
			elif err == OK:
				update_progress()
			else:
				print("there was an error")
		else:
			if !completed:
				finish_loading()
				
			if Input.is_action_just_pressed("loading_continue"):
				emit_signal("continue_pressed")

func update_progress():
	var progress : float = float(loader.get_stage()) / float(loader.get_stage_count()) * 100
	print(progress)
	
	loading_bar.value = progress

func finish_loading():
	completed = true
	loading_bar.value = 100
	level = loader.get_resource()
	loading_label.text = "Press SPACE to continue..."
	flash_tween.interpolate_property(loading_label, "custom_colors/font_color", Color(1, 1, 1, 1), Color(1, 1, 1, 0.2), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	flash_tween.start()

func _on_ReadyTimer_timeout():
	ready = true


func _on_FlashTween_tween_all_completed():
	flash_tween_2.interpolate_property(loading_label, "custom_colors/font_color", Color(1, 1, 1, 0.2), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	flash_tween_2.start()


func _on_FlashTween2_tween_all_completed():
	flash_tween.interpolate_property(loading_label, "custom_colors/font_color", Color(1, 1, 1, 1), Color(1, 1, 1, 0.2), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	flash_tween.start()
