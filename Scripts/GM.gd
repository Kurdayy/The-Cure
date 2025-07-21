extends Node2D

class_name GM

@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player_character")
@onready var camera: Camera2D = get_tree().current_scene.get_node("MainCamera")
@onready var room_manager: Node2D = get_tree().current_scene.get_node("RoomManager")

var GlobalFlags: Array[bool] 
@onready var TotalFlags: int = Flag.size()

enum Flag {
	Empty,
	KeycardObtained,
	FuelPickedUp,
	FartFetishAquired,
	ExampleOfGlobalFlag
}


func _ready():
	
	reset_flags()
	
	
	
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
	
	
