extends Control
class_name GUI_Controller

var inventory_control
var inventory_gui_slots: Array[InventorySlot]
var inventory_big_slot: InventorySlot
var inventory_big: Item
var inventory: Array[Item]
var inventory_max_size: int = 6

var inventory_empty_hand: Item

var callback: Callable
var transition_time: float = 2
var time_elapsed: float = 0
var fade_in: bool = true
var transition_object
@onready var transition_prefab = preload("res://Scenes/Prefabs/elevator_transition.tscn")
@onready var TimerControl = $TimerControl
@onready var TimerLabel = $TimerControl/TimeLabel
var tmax = 60000 # 60 seconds



func elevator_transition(transition_callback: Callable, finish_callback: Callable):
	print("elevator transition called")
	transition_object = transition_prefab.instantiate()
	transition_object.finish_callback = finish_callback
	transition_object.transition_callback = transition_callback
	add_child(transition_object)


func _ready():
	
	#Big inventory slot setup
	inventory_big_slot = $SlotBig
	inventory_empty_hand = preload("res://Items/item_hand_empty.tres")
	inventory_big = inventory_empty_hand
	inventory_big_slot.import_item(inventory_big)
	
	#Inventory setup for slots
	inventory_control = $InventoryControl
	
	var idx = 0
	for c in inventory_control.get_children(false):
		if c is InventorySlot:
			c.slot_n = idx
			inventory_gui_slots.append(c)
			idx += 1
				
	inventory.append(preload("res://Items/item_tie.tres"))
	
	update_inventory_gui()
	

#Reset variables and reload our ready function
func reset_inventory():
	inventory.clear()
	inventory_gui_slots.clear()
	inventory_big_slot = null
	_ready()
	
	
#update timer based on time in ms
func timer_update(time: float):
	var tms = int((int(time * 1000) % 1000) / 10.0)
	var tsec:int = floor(time)
	var tsformat = "%0*d"
	var msformat = "%0*d"
	TimerLabel.text = "00:" + tsformat % [2, 59 - tsec] + ":" + msformat % [2, 99 - tms]


func timer_finish():
	TimerLabel.text = "00:00:00"


##Attempts to add an item to the inventory, can add big items to the double slot. Returns a value based on success.	
func add_inventory_item(item: Item, bigslot: bool = false) -> bool:
	if bigslot:
		if inventory_big == inventory_empty_hand:
			inventory_big = item
			inventory_big_slot.import_item(inventory_big)
			inventory_big_slot.animate_pickup()
			return true
		else:
			print("Item already held, can't pick up.")
			return false
	
	if (inventory.size() < inventory_max_size):
		inventory.append(item)
		update_inventory_gui()
		inventory_gui_slots[inventory.size() - 1].animate_pickup()
		return true
	else:
		print("Inventory too full")
		return false


##Attempts to remove the item held in the double slot, returns a value based on success
func remove_held_item() -> bool:
	if inventory_big == inventory_empty_hand:
		printerr("Tried to remove empty item")
		return false
	
	# CODE FOR DROPPING ITEM GOES HERE
	#
	#
	#
	inventory_big = inventory_empty_hand
	inventory_big_slot.import_item(inventory_big)
	return true


##Removes an item by it's reference, returns value based on success
func remove_inventory_item(item: Item) -> bool:
	var idx =  inventory.find(item)
	
	if idx != -1:
		inventory.remove_at(idx)
		update_inventory_gui()
		return true
	else:
		printerr("Item ", item, " does not exist in inventory!")
		return false
	


##Updates inventory slots to match inventory data
func update_inventory_gui():
	var i_size = inventory.size()
	var s_size = inventory_gui_slots.size()
	var i_idx = 0
	var s_idx = 0
	
	# fill slots with appropriate information
	while (i_idx < i_size):
		inventory_gui_slots[i_idx].import_item(inventory[i_idx])
		i_idx += 1
		s_idx += 1
	
	# Clear remaining slots	
	while (s_idx < s_size):
		inventory_gui_slots[s_idx].empty_slot()
		s_idx += 1
	
