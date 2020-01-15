extends Node2D

onready var player = $Player
onready var player_camera = $PlayerCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	player_camera.attach_to(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
