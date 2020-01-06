extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MOVE_SPEED = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var move_vec = Vector2()
	var look_vec = get_global_mouse_position() - global_position
	var feet = get_child(0)
	var body = get_child(1)
	
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
		
#	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
	body.global_rotation = atan2(look_vec.y, look_vec.x)
	feet.global_rotation = atan2(move_vec.y, move_vec.x)
	
	if move_vec == Vector2(0, 0):
		body.play("idle_rifle")
		feet.play("idle")
	else:
		body.play("move_rifle")
		feet.play("walk")