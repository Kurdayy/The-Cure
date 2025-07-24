extends Object_Interactable

@onready var item = preload("res://Items/item_fuel.tres")

	
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
		
func on_interact(player: CharacterBody2D):
	print("Interact with item '", self, "'")
	var diff: Vector2 = Global.player.global_position - global_position
	if diff.length() <= max_interact_dist:
		if Global.gui_control.add_inventory_item(item, true):
			Global.set_flag(Global.Flag.FuelPickedUp, true)
			player.remove_interactable(self)
			queue_free() #deletes nwdode
