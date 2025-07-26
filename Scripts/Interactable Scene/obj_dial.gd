extends Object_Interactable

@export var power_val: int = 5
@export var enabled: bool = false

@onready var power_master: InteractableScene = self.get_parent().get_parent()
var rot_offset: float = 45

func _ready():
	z_index = int(position.y)
	if enabled:
		rotation_degrees = rot_offset
	else:
		rotation_degrees = -rot_offset
		
	Global.set_flag(flag_to_set, enabled)
	

func on_interact(_player: CharacterBody2D):
	toggle_dial()


func toggle_dial():
	if enabled:
		enabled = false
		rotation_degrees = -rot_offset
		if !Global.GlobalFlags[Global.Flag.POW_FUSEBLOWN]:
			Global.set_flag(flag_to_set, false)
			power_master.update_power(-power_val, flag_to_set)
			
	else:
		enabled = true
		rotation_degrees = rot_offset
		if !Global.GlobalFlags[Global.Flag.POW_FUSEBLOWN]:
			Global.set_flag(flag_to_set, true)
			power_master.update_power(power_val, flag_to_set)
			

	
func set_unselected():
	pass
	
func set_selected():
	pass





func _on_area_2d_mouse_entered() -> void:
	set_selected()
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	set_unselected()
	pass # Replace with function body.


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		on_interact(Global.player)
