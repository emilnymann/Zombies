extends CanvasLayer

onready var health_counter = $Health/HpContainer/HpCounter
onready var ammo_counter = $AmmoFlashlight/AmmoFlashlightContainer/AmmoContainer/AmmoCounter
onready var ammo_reserve_counter = $AmmoFlashlight/AmmoFlashlightContainer/AmmoContainer/AmmoReserveCounter
onready var flashlight_bar = $AmmoFlashlight/AmmoFlashlightContainer/FlashlightContainer/FlashlightBar

var player

func _ready():
	pass
	
func _process(delta):
	var flashlight_power = player.flashlight_power
	
	flashlight_bar.value = flashlight_power
	
func set_player(p):
	player = p
	
	player.connect("health_changed", self, "_on_Player_health_changed")
	player.connect("ammo_changed", self, "_on_Player_fired")
	
	health_counter.text = str(player.health)
	ammo_counter.text = str(player.ammo)
	ammo_reserve_counter.text = str(player.reserve_ammo)

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
	
func _on_Player_fired():
	var reserve_ammo = player.reserve_ammo
	var ammo = player.ammo
	
	ammo_counter.text = str(ammo)
	ammo_reserve_counter.text = str(reserve_ammo)