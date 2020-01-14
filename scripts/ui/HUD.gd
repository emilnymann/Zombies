extends CanvasLayer

onready var health_counter = $Health/HpContainer/HpCounter

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player").front()
	
	player.connect("health_changed", self, "_on_Player_health_changed")

func _on_Player_health_changed():
	var hp = player.health
	var max_hp = player.max_health
	var hp_color
	
	if hp >= 80:
		hp_color = Color("26a01f")
	elif hp >= 40:
		hp_color = Color("d9da27")
	else:
		hp_color = Color("b91f1f")
	
	health_counter.text = str(hp)
	health_counter.set("custom_colors/font_color", hp_color)