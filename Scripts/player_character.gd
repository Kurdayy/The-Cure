extends CharacterBody2D

@export var movement_speed: float = 200
var move_target: Vector2
var nav_max_move_gap = 50;
@onready var nav_agent: NavigationAgent2D = $player_nav
@onready var camera: Camera2D = get_tree().current_scene.get_node("MainCamera")

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
	
	#movement code
	if nav_agent.is_navigation_finished():
		return
	
	var current_agent_pos: Vector2 = global_position
	var next_path_pos: Vector2 = nav_agent.get_next_path_position()
	
	velocity = current_agent_pos.direction_to(next_path_pos) * movement_speed
	move_and_slide()
	
	
	
func input_check() -> void:
	if Input.is_action_just_pressed("interact"):
		print("interact at ", get_viewport().get_mouse_position())
	elif Input.is_action_pressed("move"):
		print("move at ", get_viewport().get_mouse_position())
		var worldpos = get_viewport().get_mouse_position() + camera.global_position
		input_move(worldpos)
		
		
	elif Input.is_action_just_pressed("inventory"):
		print("open inventory")
		
		
	
			

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
	
