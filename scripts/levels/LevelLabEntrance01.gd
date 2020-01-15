extends Node2D

onready var player = $Player
onready var player_camera = $PlayerCamera
onready var hud = $HUD
onready var pathfinding = $Pathfinding
onready var pathfinding_timer = $PathfindingRefreshTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var tree = get_tree()
		
	player_camera.attach_to(player)
	hud.set_player(player)
	tree.call_group("zombie", "set_player", player)
	tree.call_group("zombie", "set_nav", pathfinding)
	tree.call_group("zombie", "set_pathfinding_timer", pathfinding_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
