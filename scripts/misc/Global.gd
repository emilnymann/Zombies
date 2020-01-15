extends Node2D

onready var player = $Player
onready var nav2d = $Navigation2D
onready var timer = $PathfindingTimer
onready var camera = $PlayerCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("zombie", "set_pathfinding_timer", timer)
	get_tree().call_group("zombie", "set_player", player)
	get_tree().call_group("zombie", "set_nav", nav2d)

# warning-ignore:unused_argument
func _process(delta):
	# camera follows player
	camera.global_position = player.global_position


func _on_ZombieTrigger_body_entered(body):
	if body.name == "Player":
		get_tree().call_group("dev_world_zombie", "activate")