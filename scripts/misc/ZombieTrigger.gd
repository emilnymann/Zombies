extends Area2D

export var group_name : String

func _ready():
	pass # Replace with function body.

func _on_ZombieTrigger_body_entered(body):
	if body.name == "Player":
		get_tree().call_group(group_name, "activate")
