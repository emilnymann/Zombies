extends CanvasLayer

onready var loading_bar = $LoadingVBoxContainer/LoadingBar
onready var loading_label = $LoadingVBoxContainer/LoadingLabel

var loader : ResourceInteractiveLoader
var loaded = false
var ready = false
var level_to_load : String
var level_display_name : String

func _ready():
	loader = ResourceLoader.load_interactive(level_to_load)
	loading_label.text = "Loading " + level_display_name + "..."

func _process(delta):
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
			finish_loading()

func update_progress():
	var progress : float = float(loader.get_stage()) / float(loader.get_stage_count()) * 100
	print(progress)
	
	loading_bar.value = progress

func finish_loading():
	loading_bar.value = 100
	loading_label.text = "Press SPACE to continue..."

func _on_ReadyTimer_timeout():
	ready = true
