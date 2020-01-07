extends KinematicBody2D

const MOVE_SPEED = 200
var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if health <= 0:
		kill()

func take_damage(amount):
	print("Took " + str(amount) + " damage!")
	health = health - amount
	
func kill():
	print("Died!")
	queue_free()