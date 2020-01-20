extends Area2D

export var amount = 31

onready var sprite = $Sprite
onready var light = $Light2D



func _on_AmmoPouch_body_entered(body):
	if body.name == "Player" && body.has_method("add_ammo"):
		if body.add_ammo(amount):
			queue_free()
