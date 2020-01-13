extends CanvasLayer

onready var health_counter = $MarginContainer/HpContainer/HpCounter

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player").front()
	
	player.connect("health_changed", self, "_on_Player_health_changed")

func _on_Player_health_changed():
	health_counter.text = str(player.health)