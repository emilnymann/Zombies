extends KinematicBody2D

const MOVE_SPEED = 200
var health = 100
onready var blood = load("res://entities/fx/BloodSpatter.tscn")
onready var body = $Body

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if health <= 0:
		kill()

func take_damage(amount, direction):
	print("Took " + str(amount) + " damage!")
	var blood_instance = blood.instance()
	blood_instance.global_position = body.global_position
	blood_instance.global_rotation = ( direction * -1 ).angle()
	get_parent().add_child(blood_instance)
	health = health - amount
	
func kill():
	print("Died!")
	queue_free()