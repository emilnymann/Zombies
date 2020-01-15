extends CanvasLayer

var first_level

# Called when the node enters the scene tree for the first time.
func _ready():
	
	first_level = load("res://entities/levels/LevelLabEntrance01.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayButton_pressed():
	get_tree().change_scene_to(first_level)
