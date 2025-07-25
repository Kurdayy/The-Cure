class_name InventorySlot
extends PanelContainer

@export var item_name: String = ""
@export var empty: bool = true
@export var texture: Texture2D
var slot_n: int = 0
var mouseover: bool = false
var selected: bool = false
var select_offset: float = 140 #px vertical offset
const select_twn_duration: float = 0.15
const pickup_twn_delay: float = 0.6
var tween: Tween
@onready var pos_rest: float = position.y

#func setup_slot(new_item, texture):
	#self.item_name = item_name
	#self.texture = texture
	#$Panel/ItemLabel.text = item_name
	#$Panel/ItemTexture.texture = self.texture
	#empty = false

func animate_pickup():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, pos_rest - select_offset), select_twn_duration)
	tween.tween_property(self, "position", Vector2(position.x, pos_rest), select_twn_duration).set_delay(pickup_twn_delay)
	
	
func animate_up(tween_duration: float = select_twn_duration):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, pos_rest - select_offset), tween_duration)
	
	
func animate_down(tween_duration: float = select_twn_duration):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, pos_rest), tween_duration)

	
func import_item(item: Item):
	#r_item.item_description
	self.item_name = item.item_name
	self.texture = item.item_texture
	$Panel/ItemLabel.text = self.item_name
	$Panel/ItemTexture.texture = self.texture
	empty = false
	
func empty_slot():
	self.item_name = ""
	self.texture = null
	$Panel/ItemLabel.text = item_name
	$Panel/ItemTexture.texture = self.texture
	

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("interact"):
			print("inventory item: ", item_name)
	


func _on_panel_mouse_entered() -> void:
	mouseover = true
	animate_up()
	#if tween:
		#tween.kill()
	#tween = get_tree().create_tween()
	#tween.tween_property(self, "position", Vector2(position.x, pos_rest - select_offset), select_twn_duration)
	#pass # Replace with function body.


func _on_panel_mouse_exited() -> void:
	mouseover = false
	animate_down()
	#if tween:
		#tween.kill()
	#tween = get_tree().create_tween()
	#tween.tween_property(self, "position", Vector2(position.x, pos_rest), select_twn_duration)
	#pass # Replace with function body.
