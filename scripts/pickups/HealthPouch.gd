extends Area2D

export var amount = 5

onready var sprite = $Sprite
onready var light = $Light2D



func _on_AmmoPouch_body_entered(body):
	if body.name == "Player" && body.has_method("add_health"):
		if body.add_health(amount):
			queue_free()
