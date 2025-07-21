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
var interactables_in_range: Array[Object_Interactable]
var nearest_interactable: Object_Interactable

func _ready() -> void:
	nav_agent.path_desired_distance = 6.0
	nav_agent.target_desired_distance = 6.0
	interactables_in_range.clear()
	
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
	
	#no velocity, return function
	if velocity == Vector2.ZERO:
		return
	
	if velocity.x > 0 && input_map.x <= 0:
		velocity.x = clamp(velocity.x - (movement_deccel * delta), 0, movement_speed)
	elif velocity.x < 0 && input_map.x >= 0:
		velocity.x = clamp(velocity.x + (movement_deccel * delta), -movement_speed, 0)
			
	if velocity.y > 0 && input_map.y <= 0:
		velocity.y = clamp(velocity.y - (movement_deccel * delta), 0, movement_speed)
	elif velocity.y < 0 && input_map.y >= 0:
		velocity.y = clamp(velocity.y + (movement_deccel * delta), -movement_speed, 0)	
	
	#additionally check for updates to interactables after moving
	move_and_slide()
	update_nearest_interactable()
	
	

func update_nearest_interactable():
	var n_interactables: int = interactables_in_range.size()

	if n_interactables == 0 || n_interactables == null:
		if nearest_interactable != null:
			nearest_interactable = null #return to ashes
		return
		
	elif n_interactables == 1:
		if nearest_interactable != interactables_in_range[0]:
			nearest_interactable = interactables_in_range[0]
			nearest_interactable.set_selected()
			print("New selection: ", nearest_interactable)
	
	else:
		var mindist: float = 900000 #really fucking high n#
		var idx: int = 0
		for i in range(0, n_interactables):
			var dist: Vector2 = interactables_in_range[i].global_position - global_position
			var len = dist.length()
			if len < mindist:
				idx = i
				mindist = len
		
		if nearest_interactable == interactables_in_range[idx]:
			return
		if nearest_interactable != null:
			nearest_interactable.set_unselected()
		nearest_interactable = interactables_in_range[idx]
		nearest_interactable.set_selected()
		print("New selection: ", nearest_interactable)
	
	
		
func remove_interactable(obj: Object_Interactable):
	if nearest_interactable == obj:
		nearest_interactable = null
	var idx = interactables_in_range.find(obj)
	if idx >= 0: #if the object is within the array
		interactables_in_range.remove_at(idx)
		update_nearest_interactable()
	
	

func try_interact():
	
	if nearest_interactable == null:
		print("Interact failed, no applicable objects")
		return
		
	nearest_interactable.on_interact(self)
	return	




	
	
	
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
		try_interact()
		
	elif Input.is_action_pressed("move"):
		print("move at ", get_viewport().get_mouse_position())
		var worldpos = get_viewport().get_mouse_position() + camera.global_position
		input_move(worldpos)
		
	elif Input.is_action_just_pressed("inventory"):
		print("open inventory")
		Global.list_flags()
	
	#perform movement input checks and update the input map with new values
	move_check_h("move_left", "move_right", -1)
	move_check_h("move_right", "move_left", 1)
	move_check_v("move_up", "move_down", -1)
	move_check_v("move_down", "move_up", 1)
			
			

func input_move(pos: Vector2) -> void:
	var nav_map = get_world_2d().navigation_map
	var point = NavigationServer2D.map_get_closest_point(nav_map, pos)
	
	set_move_target(point)
	


func _on_player_interact_area_area_entered(area: Area2D) -> void:
	var obj_parent = area.get_parent()
	if obj_parent is Object_Interactable:
		print("Collided with interactable: ", obj_parent)
		if !interactables_in_range.has(obj_parent): #if the object is not contained in the array
			interactables_in_range.append(obj_parent)
			#this might be overkill not sure, depends how everything is processed
			update_nearest_interactable()


func _on_player_interact_area_area_exited(area: Area2D) -> void:
	var obj_parent = area.get_parent()
	if obj_parent is Object_Interactable:
		print("Uncollided with interactable: ", obj_parent)
		var idx = interactables_in_range.find(obj_parent)
		if idx >= 0: #if the object is within the array
			interactables_in_range.remove_at(idx)
			obj_parent.set_unselected()
			update_nearest_interactable()
			
