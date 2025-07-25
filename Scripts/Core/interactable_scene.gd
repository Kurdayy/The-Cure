class_name InteractableScene
extends Node2D


func kill_scene():
	Global.player.input_enabled = true
	Global.interactable_scene.hide()
	queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		call_deferred("kill_scene")
		#dkill_scene()
