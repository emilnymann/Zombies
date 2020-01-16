extends Node2D

export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	global_rotation_degrees += 1 * speed * delta
