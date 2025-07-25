extends Object_Interactable

@export var room_to: String = ""
@export var transition_id: int = 0
@export var transition_offset: Vector2 = Vector2(0, 0)
@onready var transition_mask = preload("res://Scenes/Prefabs/transition.tscn")
@onready var room_from: Room:
	get:
		var parent = self.get_parent()
		while parent is not Room:
			parent = parent.get_parent()
		return parent
			

func on_interact(player: CharacterBody2D):	
	#if Global.GlobalFlags[Global.Flag.KeycardObtained]:
	Global.gui_control.elevator_transition(transition_load, transition_finish)
	Global.player.input_enabled = false
		

func transition_load():
	Global.room_manager.room_transition(room_from, room_to, transition_id, transition_offset)
	
func transition_finish():
	Global.player.input_enabled = true
	Global.player.remove_interactable(self)
