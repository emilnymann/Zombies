extends KinematicBody2D

const MOVE_SPEED = 200
var health = 100
onready var blood = load("res://entities/fx/BloodSpatter.tscn")
onready var body = $Body

var nav2d
var player
var timer
var path : = PoolVector2Array()
var is_active = true
var is_moving = false
var move_dir = global_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	nav2d = get_parent().get_node("Navigation2D")
	timer = get_parent().get_node("PathfindingTimer")
	
	timer.connect("timeout", self, "_on_PathfindingTimer_timeout")
	
func _process(delta):
	if is_active:
		var distance_to_walk = MOVE_SPEED * delta
	
		while distance_to_walk > 0 and path.size() > 0:
			is_moving = true
			var distance_to_next_point = position.distance_to(path[0])
			if distance_to_walk <= distance_to_next_point:
				var direction = position.direction_to(path[0])
				position += direction * distance_to_walk
				move_dir = atan2(direction.y, direction.x)
			else:
				position = path[0]
				path.remove(0)
			
			distance_to_walk -= distance_to_next_point
			
		if is_moving:
			global_rotation = lerp(global_rotation, move_dir, 0.75)

func _physics_process(delta):
	if health <= 0:
		kill()
	
func set_player(p):
	player = p
	
func set_nav(n):
	nav2d = n

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

func _on_PathfindingTimer_timeout():
	if is_active:
		var new_path = nav2d.get_simple_path(global_position, player.global_position)
		path = new_path
