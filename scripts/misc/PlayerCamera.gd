extends Camera2D

onready var attached_to = $"."

func _ready():
	pass

# warning-ignore:unused_argument
func _process(delta):
	
	# camera follows the entity that it has been attached to
	global_position = attached_to.global_position
	
	# smooth camera between player position and mouse position * strength factor
	offset = ((( get_global_mouse_position() + global_position ) / 2 ) - global_position ) * 0.5

func attach_to(node):
	attached_to = node