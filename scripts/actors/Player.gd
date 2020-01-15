extends KinematicBody2D

var bullet_trace = load("res://entities/fx/BulletTrace.tscn")

const MOVE_SPEED = 20000
const FIRE_RATE = 0.1 # time between each bullet
const DAMAGE = 20
var max_health = 100
var max_ammo = 31
var max_flashlight_power = 100
var health = max_health
var ammo = max_ammo
var flashlight_power = max_flashlight_power
var flashlight_power_factor = 0.2
var fire_ready = true
var flashlight_toggle = false # is flashlight on or off?

var is_moving = false
var is_firing = false
var is_reloading = false

onready var blood = load("res://entities/fx/BloodSpatter.tscn")
onready var fire_audio = $Audio/Fire
onready var reloadstart_audio = $Audio/ReloadStart
onready var reloadend_audio = $Audio/ReloadEnd
onready var flashlight_toggle_audio = $Audio/FlashlightToggle
onready var raycast = $Body/RayCastGun
onready var muzzle = $Body/MuzzleFlash
onready var flashlight = $Body/Flashlight
onready var muzzletimer = $Body/MuzzleFlash/Timer
onready var muzzlefx = $Body/MuzzleFx
onready var firetimer = $FirerateTimer
onready var reloadtimer = $ReloadTimer
onready var feet = $Feet
onready var body = $Body

signal health_changed
signal ammo_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
		toggle_flashlight()
			
	if Input.is_action_pressed("fire"):
		if fire_ready == true and ammo > 0 and !is_reloading:
			fire_ready = false
			firetimer.start(FIRE_RATE)
			fire()
			
	if Input.is_action_just_pressed("reload"):
		if !is_reloading && ammo < max_ammo:
			reload()
			
		
# warning-ignore:return_value_discarded
	move_and_slide(move_vec * MOVE_SPEED * delta)
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	if move_vec == Vector2(0, 0):
		is_moving = false
		feet.global_rotation = atan2(look_vec.y, look_vec.x)
	else:
		is_moving = true
	
	if flashlight_toggle && flashlight_power > 0:
		flashlight_power -= (1 * flashlight_power_factor)
	elif !flashlight_toggle && flashlight_power < max_flashlight_power:
		flashlight_power += (1 * flashlight_power_factor)
		
	if flashlight_power < 1:
		toggle_flashlight()
	
	# ANIMATION HANDLING
	if is_moving:
		feet.play("walk")
		feet.global_rotation = atan2(move_vec.y, move_vec.x)
		if !is_reloading && !is_firing:
			body.play("move_rifle")
	else:
		feet.play("idle")
		if !is_reloading && !is_firing:
			body.play("idle_rifle")
		
func fire():
	is_firing = true
	ammo -= 1
	fire_audio.play()
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
		
	emit_signal("ammo_changed")
	
func reload():
	reloadstart_audio.play()
	reloadtimer.start(-1)
	is_reloading = true
	body.play("reload_rifle")
	
func toggle_flashlight():
	flashlight_toggle_audio.play()
	if !flashlight_toggle:
		if flashlight_power > 1:
			flashlight_toggle = true
			flashlight.visible = true
	else:
		flashlight_toggle = false
		flashlight.visible = false
		
func take_damage(amount, direction):
	print("Player took " + str(amount) + " damage!")
	var blood_instance = blood.instance()
	blood_instance.global_position = body.global_position
	blood_instance.global_rotation = ( direction * -1 ).angle()
	get_parent().add_child(blood_instance)
	health = health - amount
	emit_signal("health_changed")
	
func kill():
	print("You died!")

func _on_muzzle_timeout():
	muzzle.visible = false
	muzzlefx.emitting = false;

func _on_FirerateTimer_timeout():
	is_firing = false
	fire_ready = true

func _on_ReloadTimer_timeout():
	reloadend_audio.play()
	ammo = max_ammo
	emit_signal("ammo_changed")
	is_reloading = false
