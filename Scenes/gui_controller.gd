extends Control
class_name GUI_Controller

var callback: Callable
var transition_time: float = 2
var time_elapsed: float = 0
var fade_in: bool = true
var transition_object
@onready var transition_prefab = preload("res://Scenes/Prefabs/elevator_transition.tscn")


func elevator_transition(transition_callback: Callable, finish_callback: Callable,):
	print("elevator transition called")
	transition_object = transition_prefab.instantiate()
	transition_object.finish_callback = finish_callback
	transition_object.transition_callback = transition_callback
	add_child(transition_object)
