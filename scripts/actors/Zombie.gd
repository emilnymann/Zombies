extends KinematicBody2D

export var MOVE_SPEED = 300
export var DAMAGE = 10
export var health = 100

# effects
onready var blood = load("res://entities/fx/BloodSpatter.tscn")

# audio
onready var impact_sound_1 = $Audio/Impact01
onready var impact_sound_2 = $Audio/Impact02

# logic nodes
onready var body = $Body
onready var raycast = $AttackRaycast
onready var attack_timer = $AttackTimer

var nav2d
var player
var timer
var path : = PoolVector2Array()
var is_active = false
var is_moving = false
var is_attacking = false
var move_dir = global_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_timer.connect("timeout", self, "_on_AttackTimer_timeout")
	
func _process(delta):
	pass

func _physics_process(delta):
	
	if health <= 0:
		kill()
		
	if is_active:
		var coll = raycast.get_collider()
		var distance_to_walk = MOVE_SPEED * delta
		
		if raycast.is_colliding() and coll.has_method("take_damage") and coll.name == "Player" and !is_attacking:
			is_attacking = true
			is_moving = false
			coll.take_damage(DAMAGE, raycast.get_collision_normal())
			attack_timer.start(0.5)
	
		while distance_to_walk > 0 and path.size() > 0 and !is_attacking:
			is_moving = true
			var distance_to_next_point = position.distance_to(path[0])
			if distance_to_walk <= distance_to_next_point:
				var direction = position.direction_to(path[0])
				move_and_slide(direction * (MOVE_SPEED))
				move_dir = atan2(direction.y, direction.x)
			else:
				position = path[0]
				path.remove(0)
				is_moving = false
			
			distance_to_walk -= distance_to_next_point
			
		global_rotation = move_dir
		
		if is_moving:
			body.play("move")
		elif is_attacking:
			body.play("attack")
		else:
			body.play("idle")
	
func set_player(p):
	player = p
	
func set_nav(n):
	nav2d = n

func set_pathfinding_timer(pft):
	timer = pft
	timer.connect("timeout", self, "_on_PathfindingTimer_timeout")

func take_damage(amount, direction):
	
	var rng = randi()%3+1
	
	print("Zombie took " + str(amount) + " damage!")
	var blood_instance = blood.instance()
	blood_instance.global_position = body.global_position
	blood_instance.global_rotation = ( direction * -1 ).angle()
	get_parent().add_child(blood_instance)
	health = health - amount
	move_and_slide((direction * -1) * 500)
	
	match rng:
		1:
			impact_sound_1.play()
		2:
			impact_sound_2.play()
	
func kill():
	print("Died!")
	queue_free()
	
func activate():
	is_active = true

func _on_PathfindingTimer_timeout():
	if is_active:
		var new_path = nav2d.get_simple_path(global_position, player.global_position)
		path = new_path
		
func _on_AttackTimer_timeout():
	is_attacking = false
