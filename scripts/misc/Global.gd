extends Node2D

onready var player = $Player
onready var nav2d = $Navigation2D
onready var timer = $PathfindingTimer
onready var trigger = $ZombieTrigger

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("zombie", "set_pathfinding_timer", timer)
	get_tree().call_group("zombie", "set_player", player)
	get_tree().call_group("zombie", "set_nav", nav2d)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ZombieTrigger_body_entered(body):
	if body.name == "Player":
		get_tree().call_group("dev_world_zombie", "activate")