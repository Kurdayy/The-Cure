class_name InteractableScene
extends Node2D


func kill_scene():
	Global.player.input_enabled = true
	Global.interactable_scene.hide()
	self.hide()
	#ddddddddddqueue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && self.visible:
		call_deferred("kill_scene")
		#kill_scene()
