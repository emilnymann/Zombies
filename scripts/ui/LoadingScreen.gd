extends CanvasLayer

onready var loading_bar = $LoadingVBoxContainer/LoadingBar
onready var loading_label = $LoadingVBoxContainer/LoadingLabel

var loader : ResourceInteractiveLoader
var loaded = false

func _ready():
	loader = ResourceLoader.load_interactive("res://entities/levels/LevelLabEntrance01.tscn")

func _process(delta):
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
	loading_bar.value = progress

func finish_loading():
	loading_bar.value = 100
	loading_label.text = "Press SPACE to continue..."