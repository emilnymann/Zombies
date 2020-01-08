extends KinematicBody2D

var bullet_trace = load("res://entities/fx/BulletTrace.tscn")

const MOVE_SPEED = 300
const FIRE_RATE = 0.1 # time between each bullet
const DAMAGE = 20
var fire_ready = true
var flashlight_toggle = false # is flashlight on or off?


onready var raycast = $Body/RayCastGun
onready var camera = $Camera2D
onready var muzzle = $Body/MuzzleFlash
onready var muzzletimer = $Body/MuzzleFlash/Timer
onready var muzzlefx = $Body/MuzzleFx
onready var firetimer = $FirerateTimer
onready var feet = $Feet
onready var body = $Body

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func _physics_process(delta):
	var move_vec = Vector2()
	var look_vec = get_global_mouse_position() - global_position
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
		if fire_ready == true:
			fire_ready = false
			firetimer.start(FIRE_RATE)
			fire()
			
		
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
	
	# smooth camera between player position and mouse position * strength factor
	camera.offset = ((( get_global_mouse_position() + global_position ) / 2 ) - global_position ) * 0.5
		
func fire():
	var bullet_trace_instance = bullet_trace.instance()
	muzzle.visible = true
	muzzlefx.emitting = true
	muzzletimer.start(-1)
	var coll = raycast.get_collider()
	bullet_trace_instance.set_point_position(0, muzzlefx.global_position)
	if raycast.is_colliding():
		bullet_trace_instance.set_point_position(1, raycast.get_collision_point())
		if coll.has_method("take_damage"):
			coll.take_damage(DAMAGE, raycast.get_collision_normal())
	else:
		bullet_trace_instance.set_point_position(1, ( get_global_mouse_position() - global_position ) * 10)
	
	get_parent().add_child(bullet_trace_instance)

func _on_muzzle_timeout():
	muzzle.visible = false
	muzzlefx.emitting = false;


func _on_FirerateTimer_timeout():
	fire_ready = true