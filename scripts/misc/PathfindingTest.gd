extends Node2D

onready var player = $Player
onready var zombie = $Zombie
onready var line = $Line2D
onready var nav2d = $Navigation2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("dev_path"):
			var path = nav2d.get_simple_path(zombie.global_position, player.global_position)
			line.points = path
			zombie.path = path
