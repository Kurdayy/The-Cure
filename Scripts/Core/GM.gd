extends Node2D

class_name GM


## DEBUG CONSTANTS
const DEBUG_SHOW_MAIN_MENU_ON_STARTUP: bool = false
const DEBUG_TIMER_ENABLED: bool = false


#@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player_character")
@onready var camera: Camera2D = get_tree().current_scene.get_node("MainCamera")
@onready var room_manager: Node2D = get_tree().current_scene.get_node("RoomManager")
@onready var interactable_scene = get_tree().current_scene.get_node("Interactable").get_child(0)
#@onready var gui_control: GUI_Controller = get_tree().current_scene.get_node("GUI").get_child(0)
var gui_control: GUI_Controller
var player: CharacterBody2D
@onready var main_menu = preload("res://Scenes/Prefabs/main_menu.tscn")
@onready var pause_menu = preload("res://Scenes/Prefabs/pause_menu.tscn")

#@onready var ending_slide_default = preload("res://Scenes/Prefabs/Ending Slides/ending_slide_default.tscn")
var current_ending: Ending = Ending.DEFAULT

var GlobalFlags: Array[bool] 
@onready var TotalFlags: int = Flag.size()
var time_elapsed: float
var time_enabled: bool = true
var game_paused: bool = false
var game_active: bool = false
const time_max: float = 9.9



enum Flag {
	Empty,
	KeycardObtained,
	FuelPickedUp,
	FartFetishAquired,
	ExampleOfGlobalFlag,
	POW_SAMPLER,
	POW_SUPRESSION,
	POW_BOILER,
	POW_MAINLAB,
	POW_SUBLAB,
	POW_WH,
	POW_BREAKROOM,
	POW_MNGOFFICE,
	POW_RECEPTION,
	POW_ELEVATOR,
	POW_LIQUIDSTORAGE,
	POW_SURVEILLANCE,
	POW_MISC,
	POW_FUSEBLOWN
}

enum Ending {
	DEFAULT,
	CURE,
	STAIRS,
	POW_LOST
}

func _ready():
	
	gui_control = get_tree().current_scene.get_node("GUI").get_child(0)
	player = get_tree().current_scene.get_node("player_character")
	reset_flags()
	if DEBUG_SHOW_MAIN_MENU_ON_STARTUP:
		player.input_enabled = false
		spawn_main_menu()
	else:
		var menu: MainMenu = gui_control.get_node("MainMenu")
		if menu:
			menu.queue_free()
		call_deferred("start_game")
	
	

func spawn_main_menu():
	for scene in interactable_scene.get_children(false):
		scene.queue_free()
	var menu: MainMenu = gui_control.get_node("MainMenu")
	if !menu:
		menu = main_menu.instantiate()
		gui_control.add_child(menu)
	gui_control.InGameGUI.hide()
	game_active = false
		
		

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
	gui_control.InGameGUI.show()
	time_elapsed = 0
	time_enabled = true
	game_active = true
	game_paused = false
	current_ending = Ending.DEFAULT
	
	
func _process(delta):
	if time_enabled && DEBUG_TIMER_ENABLED:
		time_elapsed += delta
		gui_control.timer_update(time_elapsed)
		if time_elapsed >= time_max:
			loop_finish()

## Pause game and player control, then spawn pause menu gui element	
func pause():
	time_enabled = false
	player.input_enabled = false
	game_paused = true
	var pm = pause_menu.instantiate()
	gui_control.add_child(pm)
	gui_control.PauseMenu = pm
	gui_control.InGameGUI.hide()
	
	
## Resume game and player control
func unpause():
	time_enabled = true
	player.input_enabled = true
	game_paused = false
	gui_control.PauseMenu.queue_free()
	gui_control.InGameGUI.show()
			
			
##Cleanup for loop		
func loop_finish():
	print("Loop finished")
	time_enabled = false
	gui_control.timer_finish()
	player.input_enabled = false
	game_active = false
	var slide
	match(current_ending):
		Ending.DEFAULT:
			slide = preload("res://Scenes/Prefabs/Ending Slides/ending_slide_default.tscn")
		Ending.STAIRS:
			slide = preload("res://Scenes/Prefabs/Ending Slides/ending_slide_staircase.tscn")
		Ending.POW_LOST:
			slide = preload("res://Scenes/Prefabs/Ending Slides/ending_slide_supression.tscn")
		_: # default case
			spawn_main_menu()
			return
			#escapes and doesnt play a slide
			
			
	var ending_slide = slide.instantiate()
	gui_control.add_child(ending_slide)
			
			
	
	

func reset():
	for scene in interactable_scene.get_children(false):
		scene.queue_free()
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
	
	for f in range(Flag.POW_SAMPLER, Flag.POW_FUSEBLOWN):
		GlobalFlags[f] = true
	
	print("All flags reset")

func list_flags():
	print("CURRENT GLOBAL FLAGS: ")
	for f in range(0, TotalFlags):
		print("		", Flag.keys()[f], " - ", GlobalFlags[f])
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_menu") && game_active:
		if game_paused:
			unpause()
		elif !game_paused:
			pause()
		


	
	
	
