extends Camera2D

func _ready():
	pass

# warning-ignore:unused_argument
func _process(delta):
	# smooth camera between player position and mouse position * strength factor
	offset = ((( get_global_mouse_position() + global_position ) / 2 ) - global_position ) * 0.5
