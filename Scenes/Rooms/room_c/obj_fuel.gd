extends Object_Interactable

	
#func on_interact(player: CharacterBody2D):
	#print("Interact with item '", self, "'")
	#var diff: Vector2 = Global.player.global_position - global_position
	#if diff.length() <= max_interact_dist:
		#Global.set_flag(Global.Flag.FuelPickedUp, true)
		#player.remove_interactable(self)
		#queue_free() #deletes node
			#
#
		#
