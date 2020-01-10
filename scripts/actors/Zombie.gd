extends KinematicBody2D

const MOVE_SPEED = 200
var health = 100
onready var blood = load("res://entities/fx/BloodSpatter.tscn")
onready var body = $Body

var path : = PoolVector2Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	var distance_to_walk = MOVE_SPEED * delta
	
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			position = path[0]
			path.remove(0)
		distance_to_walk -= distance_to_next_point

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