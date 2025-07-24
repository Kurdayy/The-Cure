extends Object_Interactable

@export var scene_to_load: PackedScene

func on_interact(_player: CharacterBody2D):
		Global.player.input_enabled = false
		var interact_scene = scene_to_load.instantiate()		
		Global.interactable_scene.add_child(interact_scene)
