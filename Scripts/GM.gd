extends Node2D

class_name GM

@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player_character")
@onready var camera: Camera2D = get_tree().current_scene.get_node("MainCamera")
@onready var room_manager: Node2D = get_tree().current_scene.get_node("RoomManager")
@onready var gui_control: GUI_Controller = get_tree().current_scene.get_node("GUI").get_child(0)

var GlobalFlags: Array[bool] 
@onready var TotalFlags: int = Flag.size()
var time_elapsed: float
var time_enabled: bool = true
const time_max: float = 9.9

enum Flag {
	Empty,
	KeycardObtained,
	FuelPickedUp,
	FartFetishAquired,
	ExampleOfGlobalFlag
}


func _ready():
	
	reset_flags()
	time_elapsed = 0
	
	
func _process(delta):
	if time_enabled:
		time_elapsed += delta
		gui_control.timer_update(time_elapsed)
		if time_elapsed >= time_max:
			loop_finish()
			
			
##Cleanup for loop		
func loop_finish():
	print("Time's up!")
	time_enabled = false
	gui_control.timer_finish()
	
	player.global_position = player.starting_position
	
	room_manager.queue_free()
	var mng = preload("res://Scenes/room_manager.tscn")
	room_manager = mng.instantiate()
	get_tree().current_scene.add_child(room_manager)
	gui_control.reset_inventory()
	camera.reset()
	
	
	reset_flags()
	time_elapsed = 0
	time_enabled = true
	
	
	
	
##Use flag enumerator to set the state of an existing flag
func set_flag(flag_id: Flag, state: bool) -> void:
	GlobalFlags[flag_id] = state
	print("Flag '", Flag.keys()[flag_id], "' set to: ", state)

##reset all flags
func reset_flags():
	GlobalFlags.resize(TotalFlags)
	for f in GlobalFlags:
		f = false
	print("All flags reset")

func list_flags():
	print("CURRENT GLOBAL FLAGS: ")
	for f in range(0, TotalFlags):
		print("		", Flag.keys()[f], " - ", GlobalFlags[f])
	
	
