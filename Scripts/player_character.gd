extends CharacterBody2D

#adjustable variables
@export var movement_speed: float = 200
@export var movement_accel: float = 400
@export var movement_deccel: float = 600

#global references
@onready var nav_agent: NavigationAgent2D = $player_nav
@onready var camera: Camera2D = get_tree().current_scene.get_node("MainCamera")

var move_target: Vector2
var nav_max_move_gap = 50;
var move_accel: Vector2 = Vector2(0,0)
var moveh_last: int
var movev_last: int
var input_map: Vector2 = Vector2(0, 0)

func _ready() -> void:
	nav_agent.path_desired_distance = 6.0
	nav_agent.target_desired_distance = 6.0
	
	#delayed setup
	move_target = position
	actor_setup.call_deferred()
	
	
func actor_setup() -> void:
	#wait for first physics frame for nav agent to fill
	await get_tree().physics_frame
	set_move_target(move_target)


func set_move_target(pos: Vector2)  -> void:
	move_target = pos
	nav_agent.target_position = pos
	

func _physics_process(delta: float) -> void:
	input_check()
	
	#if input accelerate to our goals
	if input_map != Vector2.ZERO:
		velocity.x = clamp(velocity.x + (input_map.x * movement_accel * delta), -movement_speed, movement_speed)
		velocity.y = clamp(velocity.y + (input_map.y * movement_accel * delta), -movement_speed, movement_speed)
		#clamp length
		if velocity.length() > movement_speed:
			velocity = velocity.normalized() * movement_speed
	
	#nothing pressed, we still have velocity, decelerate	
	if velocity != Vector2.ZERO:
		if velocity.x > 0 && input_map.x <= 0:
			velocity.x = clamp(velocity.x - (movement_deccel * delta), 0, movement_speed)
		elif velocity.x < 0 && input_map.x >= 0:
			velocity.x = clamp(velocity.x + (movement_deccel * delta), -movement_speed, 0)
			
		if velocity.y > 0 && input_map.y <= 0:
			velocity.y = clamp(velocity.y - (movement_deccel * delta), 0, movement_speed)
		elif velocity.y < 0 && input_map.y >= 0:
			velocity.y = clamp(velocity.y + (movement_deccel * delta), -movement_speed, 0)
	
	
	#nav_move() 	#Optional nav based movement
	move_and_slide()
	
	
	
func nav_move() -> void:
	#movement code
	if nav_agent.is_navigation_finished():
		return
	
	var current_agent_pos: Vector2 = global_position
	var next_path_pos: Vector2 = nav_agent.get_next_path_position()
	velocity = current_agent_pos.direction_to(next_path_pos) * movement_speed
	
	
	
func move_check_h(dir: String, oppdir: String, dirint: int) -> void:
	if Input.is_action_just_pressed(dir):
		input_map.x = dirint
	elif Input.is_action_just_released(dir):
		if Input.is_action_pressed(oppdir):
			input_map.x = -dirint
		else:
			input_map.x = 0
			
func move_check_v(dir: String, oppdir: String, dirint: int) -> void:
	if Input.is_action_just_pressed(dir):
		input_map.y = dirint
	elif Input.is_action_just_released(dir):
		if Input.is_action_pressed(oppdir):
			input_map.y = -dirint
		else:
			input_map.y = 0
	
	
func input_check() -> void:
	if Input.is_action_just_pressed("interact"):
		print("interact at ", get_viewport().get_mouse_position())
		
	elif Input.is_action_pressed("move"):
		print("move at ", get_viewport().get_mouse_position())
		var worldpos = get_viewport().get_mouse_position() + camera.global_position
		input_move(worldpos)
		
	elif Input.is_action_just_pressed("inventory"):
		print("open inventory")
	
	#perform movement input checks and update the input map with new values
	move_check_h("move_left", "move_right", -1)
	move_check_h("move_right", "move_left", 1)
	move_check_v("move_up", "move_down", -1)
	move_check_v("move_down", "move_up", 1)
			

func input_move(pos: Vector2) -> void:
	var nav_map = get_world_2d().navigation_map
	var point = NavigationServer2D.map_get_closest_point(nav_map, pos)
	
	set_move_target(point)
	
	### If you desire not being able to click on walls and move
	#var diff = point - pos
	#if (diff.length() <= nav_max_move_gap):
	#	set_move_target(point)
	#else:
	#	print("nearest point: ", point, "\ndesired pos: ", pos)
	
