extends KinematicBody2D

var bullet_trace = load("res://entities/fx/BulletTrace.tscn")

const MOVE_SPEED = 300
const FIRE_RATE = 0.1 # time between each bullet
const DAMAGE = 20
var max_health = 100
var max_ammo = 21
var health = max_health
var ammo = max_ammo
var fire_ready = true
var flashlight_toggle = false # is flashlight on or off?

onready var blood = load("res://entities/fx/BloodSpatter.tscn")
onready var raycast = $Body/RayCastGun
onready var muzzle = $Body/MuzzleFlash
onready var muzzletimer = $Body/MuzzleFlash/Timer
onready var muzzlefx = $Body/MuzzleFx
onready var firetimer = $FirerateTimer
onready var feet = $Feet
onready var body = $Body

signal health_changed
signal fired

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func _physics_process(delta):
	var move_vec = Vector2()
	var look_vec = get_global_mouse_position() - global_position
	var flashlight = get_node("Body/Flashlight")
	
	if health <= 0:
		kill()
	
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
		if fire_ready == true and ammo > 0:
			fire_ready = false
			firetimer.start(FIRE_RATE)
			fire()
			
		
	move_and_collide(move_vec * MOVE_SPEED * delta)
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	if move_vec == Vector2(0, 0):
		body.play("idle_rifle")
		feet.play("idle")
		feet.global_rotation = atan2(look_vec.y, look_vec.x)
	else:
		body.play("move_rifle")
		feet.play("walk")
		
func fire():
	ammo -= 1
	emit_signal("fired")
	var bullet_trace_instance = bullet_trace.instance()
	muzzle.visible = true
	muzzlefx.emitting = true
	muzzletimer.start(-1)
	var coll = raycast.get_collider()
	bullet_trace_instance.set_point_position(0, muzzlefx.global_position)
	if raycast.is_colliding():
		bullet_trace_instance.set_point_position(1, raycast.get_collision_point())
		get_parent().add_child(bullet_trace_instance)
		
		if coll.has_method("take_damage"):
			coll.take_damage(DAMAGE, raycast.get_collision_normal())
	else:
		var diff = ((get_global_mouse_position() - global_position) * 4) + global_position # convert global to local, apply scalar and convert back to global
		bullet_trace_instance.set_point_position(1, diff)
		get_parent().add_child(bullet_trace_instance)
		
func take_damage(amount, direction):
	print("Player took " + str(amount) + " damage!")
	var blood_instance = blood.instance()
	blood_instance.global_position = body.global_position
	blood_instance.global_rotation = ( direction * -1 ).angle()
	get_parent().add_child(blood_instance)
	emit_signal("health_changed")
	health = health - amount
	
func kill():
	print("You died!")

func _on_muzzle_timeout():
	muzzle.visible = false
	muzzlefx.emitting = false;


func _on_FirerateTimer_timeout():
	fire_ready = true