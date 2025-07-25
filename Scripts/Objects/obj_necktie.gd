extends Object_Interactable
@onready var item = preload("res://Items/item_tie.tres")

func on_interact(player: CharacterBody2D):
	if Global.gui_control.add_inventory_item(item):
		Global.set_flag(Global.Flag.KeycardObtained, true)
		player.remove_interactable(self)
		queue_free() #deletes nwdode
