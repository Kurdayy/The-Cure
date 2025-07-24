class_name MainMenu
extends Control

var fade_transition = preload("res://Scenes/Prefabs/fade_transition.tscn")
var input_lock = false


func ready():
	input_lock = false
	pass
	

func start_game():
	queue_free()
	Global.start_game()
	

func _on_b_start_pressed() -> void:
	if input_lock:
		return
	input_lock = true
	var fade = fade_transition.instantiate()
	Global.gui_control.add_child(fade)
	fade.setup(start_game, 1)
	fade.begin_transition()
	



func _on_b_options_pressed() -> void:
	if input_lock:
		return
	pass # Replace with function body.



func _on_b_quit_pressed() -> void:
	if input_lock:
		return
	get_tree().quit()


func _on_b_credits_pressed() -> void:
	if input_lock:
		return
	pass # Replace with function body.
