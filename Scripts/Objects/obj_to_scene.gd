extends Object_Interactable

@export var scene_to_load: PackedScene
@export var scn_name: String

func on_interact(_player: CharacterBody2D):
		Global.player.input_enabled = false
		
		var scene: Node2D = Global.interactable_scene.get_node_or_null(scn_name)
		
		if scene != null:
			print("found scene, ", scene ,", hidden: ", scene.visible)
			scene.show()
		else:
			var interact_scene = scene_to_load.instantiate()		
			Global.interactable_scene.add_child(interact_scene)
		
		Global.interactable_scene.show()
