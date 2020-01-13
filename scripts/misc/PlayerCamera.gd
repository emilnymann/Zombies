extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	# smooth camera between player position and mouse position * strength factor
	offset = ((( get_global_mouse_position() + global_position ) / 2 ) - global_position ) * 0.5
