extends Line2D

onready var timer = $DestroyTimer

func _ready():
	timer.start(0.05)

func _on_DestroyTimer_timeout():
	queue_free()
