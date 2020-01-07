extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MOVE_SPEED = 300
const FIRE_RATE = 0.1 # time between each bullet
const DAMAGE = 20
var time = FIRE_RATE
var flashlight_toggle = false # is flashlight on or off?

onready var raycast = $Body/RayCastGun

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var move_vec = Vector2()
	var look_vec = get_global_mouse_position() - global_position
	var feet = get_node("Feet")
	var body = get_node("Body")
	var flashlight = get_node("Body/Flashlight")
	
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
		
	if Input.is_action_just_pressed("flashlight_toggle"):
		flashlight_toggle = !flashlight_toggle
		
		if flashlight_toggle:
			flashlight.visible = true;
		else:
			flashlight.visible = false;
			
	if Input.is_action_pressed("fire"):
		time += delta
		if time >= FIRE_RATE:
			time = 0
			fire()
			
		
#	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
	body.global_rotation = atan2(look_vec.y, look_vec.x)
	feet.global_rotation = atan2(move_vec.y, move_vec.x)
	
	if move_vec == Vector2(0, 0):
		body.play("idle_rifle")
		feet.play("idle")
		feet.global_rotation = atan2(look_vec.y, look_vec.x)
	else:
		body.play("move_rifle")
		feet.play("walk")
		
func fire():
	print("FIRED!")
	var coll = raycast.get_collider()
	if raycast.is_colliding() and coll.has_method("take_damage"):
		coll.take_damage(DAMAGE)