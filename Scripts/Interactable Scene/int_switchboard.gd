extends InteractableScene

@export var max_power: float = 50
@export var obj_needle: Sprite2D
@export var dial_control: Node2D
@export var pow_overlay: ColorRect
var dial_arr: Array[Object_Interactable]
var cur_power: float = 0
var needle_animate_time: float = 0.2
var tween: Tween
var needle_base_rot: float = -54
var needle_max_rot: float = 106


func _ready():
	cur_power = 0
	pow_overlay.hide()
	for dial in dial_control.get_children(false):
		if dial is Object_Interactable:
			dial_arr.append(dial)
			if dial.enabled:
				cur_power += dial.power_val
				
	var new_rot = ((cur_power / float(max_power)) * needle_max_rot) + needle_base_rot
	obj_needle.rotation_degrees = new_rot
	
	
func update_power(add_power: int, flag: Global.Flag):
	if Global.GlobalFlags[Global.Flag.POW_FUSEBLOWN]:
		return
	match(flag):
		Global.Flag.POW_BOILER:
			if Global.GlobalFlags[Global.Flag.POW_BOILER]:
				pow_overlay.hide()
				Global.room_manager.current_room.power_overlay.hide()
			else:
				pow_overlay.show()
				Global.room_manager.current_room.power_overlay.show()
		Global.Flag.POW_SUPRESSION:
			Global.current_ending = Global.Ending.POW_LOST
			Global.loop_finish()
			return
		
	cur_power += add_power
	print("new power total: ", cur_power)
	if cur_power >= max_power:
		blow_fuse()
	else:
		update_needle()
	

func update_needle():
	if tween:
		tween.kill()
	
	var new_rot: float = ((cur_power / max_power) * needle_max_rot) + needle_base_rot
	tween = get_tree().create_tween()
	tween.tween_property(obj_needle, "rotation_degrees", new_rot, needle_animate_time)
		
func blow_fuse():
	Global.set_flag(Global.Flag.POW_FUSEBLOWN, true)
	pow_overlay.show()
	Global.room_manager.current_room.power_overlay.show()
	for dial in dial_arr:
		Global.set_flag(dial.flag_to_set, false)
	cur_power = 0
	update_needle()
	
