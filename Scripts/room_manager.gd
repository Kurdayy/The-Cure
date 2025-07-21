extends Node2D

var rooms: Array[Room]
@export var current_room: Room #set this to set the starting room
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player_character")
@onready var camera: Camera2D = get_tree().current_scene.get_node("MainCamera")


func _ready():
	
	for r in get_children(false): #get rooms attached to the manager and throw them into an array
		#im so fucking mad about this, dont need to cast to Room class explictly because we was solvin coding and shiet
		if r is Room:
			rooms.append(r)
	
	for r in rooms:
		print(r.name, " has been loaded")
		#get transition group children and connect the signals for each transition
		for t in r.transitions:
			t.connect("room_transition", room_transition)
		r.hide()
	
	update_current_room(current_room)


#returns first room by string in our array, otherwise returns null			
func get_room_from_name(s: String) -> Room:
	for r in rooms:
		if r.name == s:
			return r
	
	return null
	
	
func update_current_room(new_room: Room):
	current_room = new_room
	camera.global_position = new_room.global_position
	if !current_room.camera_locked:
		camera.camera_follow = true
		camera.global_position.y += new_room.room_height
		camera.limit_hor = Vector2(current_room.global_position.x, current_room.global_position.x)
		camera.limit_ver = Vector2(current_room.global_position.y, current_room.global_position.y + current_room.room_height)
	else:
		camera.camera_follow = false
		camera.limit_hor = Vector2(current_room.global_position.x, current_room.global_position.x)
		camera.limit_ver = Vector2(current_room.global_position.y, current_room.global_position.y)
		
	current_room.show()
	for c in current_room.get_children(true):
		c.set_process(true)
		c.set_physics_process(true)
	print("Changed current room to ", current_room)
	
	
	
func room_transition(room_from: Room, room_to_name: String, point_to_id: int, offset: Vector2):
	
	var room_to: Room = get_room_from_name(room_to_name)
	if room_to == null:
		printerr("Couldn't find room: ", room_to_name)
		return
		
	var transition = room_to.transitions[point_to_id]
	if transition == null:
		printerr("Couldn't find transition id: ", point_to_id)
		return
		
	room_from.hide()
	for c in room_from.get_children(true):
		c.set_process(false)
		c.set_physics_process(false)
	update_current_room(room_to)
	
	transition.deactivate_transition() #so we dont collide when we first enter
	player.global_position = transition.global_position + offset #mirror offset when we touch the zone
	player.z_index = player.global_position.y - current_room.position.y
	
