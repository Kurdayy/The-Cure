extends Control

var input_lock = false

func _ready():
	var TimerLabel = $TimerText
	TimerLabel.text = Global.gui_control.TimerLabel.text


func transition_to_call(callable: Callable):
	input_lock = true
	var fd = preload("res://Scenes/Prefabs/fade_transition.tscn")
	var fade = fd.instantiate()
	Global.gui_control.add_child(fade)
	fade.setup(callable, 1)
	fade.begin_transition()


func restart_game():
	queue_free()
	Global.reset()
	
func return_to_menu():
	queue_free()
	Global.spawn_main_menu()
	
	
	
func _on_b_restart_pressed() -> void:
	if input_lock:
		return
	transition_to_call(restart_game)


func _on_b_main_menu_pressed() -> void:
	if input_lock:
		return
	transition_to_call(return_to_menu)


func _on_b_quit_pressed() -> void:
	if input_lock:
		return
	get_tree().quit()


func _on_b_resume_pressed() -> void:
	if input_lock:
		return
	Global.unpause()
	queue_free()
