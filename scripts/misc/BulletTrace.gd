extends Line2D

onready var timer = $DestroyTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(0.05)



func _on_DestroyTimer_timeout():
	queue_free()
