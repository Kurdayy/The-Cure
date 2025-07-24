extends Node2D

class_name GM

#@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player_character")
@onready var camera: Camera2D = get_tree().current_scene.get_node("MainCamera")
@onready var room_manager: Node2D = get_tree().current_scene.get_node("RoomManager")
#@onready var gui_control: GUI_Controller = get_tree().current_scene.get_node("GUI").get_child(0)
var gui_control: GUI_Controller
var player: CharacterBody2D
@onready var main_menu = preload("res://Scenes/Prefabs/main_menu.tscn")

@onready var ending_slide_default = preload("res://Scenes/Prefabs/Ending Slides/ending_slide_default.tscn")
var current_ending: Ending = Ending.DEFAULT

var GlobalFlags: Array[bool] 
@onready var TotalFlags: int = Flag.size()
var time_elapsed: float
var time_enabled: bool = true
const time_max: float = 9.9

const SHOW_MAIN_MENU_ON_STARTUP: bool = false

enum Flag {
	Empty,
	KeycardObtained,
	FuelPickedUp,
	FartFetishAquired,
	ExampleOfGlobalFlag
}

enum Ending {
	DEFAULT,
	CURE
}

func _ready():
	
	gui_control = get_tree().current_scene.get_node("GUI").get_child(0)
	player = get_tree().current_scene.get_node("player_character")
	if SHOW_MAIN_MENU_ON_STARTUP:
		player.input_enabled = false
		spawn_main_menu()
	else:
		var menu: MainMenu = gui_control.get_node("MainMenu")
		if menu:
			menu.queue_free()
		call_deferred("start_game")
	
	

func spawn_main_menu():
	var menu: MainMenu = gui_control.get_node("MainMenu")
	if !menu:
		menu = main_menu.instantiate()
		gui_control.add_child(menu)
		
		

func start_game():
	if !room_manager:
		var mng = preload("res://Scenes/room_manager.tscn")
		room_manager = mng.instantiate()
		get_tree().current_scene.add_child(room_manager)
	else:
		room_manager.queue_free()
		var mng = preload("res://Scenes/room_manager.tscn")
		room_manager = mng.instantiate()
		get_tree().current_scene.add_child(room_manager)
	gui_control.reset_inventory()
	camera.reset()
	reset_flags()
	player.input_enabled = true
	player.global_position = player.starting_position
	time_elapsed = 0
	time_enabled = true
	
	
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
	player.input_enabled = false
	
	match(current_ending):
		Ending.DEFAULT:
			var ending_slide = ending_slide_default.instantiate()
			gui_control.add_child(ending_slide)
			
			
	
	

func reset():
	room_manager.queue_free()
	var mng = preload("res://Scenes/room_manager.tscn")
	room_manager = mng.instantiate()
	get_tree().current_scene.add_child(room_manager)
	
	start_game()
	
	
	
	
	
	
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
	
	
