extends Area2D

@export var room_to: String = "room_lab"
@export var point_to_id: int = 0
@export var active_transition: bool = true
@export var locked: bool = false
##true for horizontal false for vertical transitions
@export var dirh: bool = true
var tweak_dist: float = 0.9
@onready var parent: Room = get_parent().get_parent() #dirty foul creation

	

signal room_transition(room_from: Node2D, room_to: String, point_to: int, offset: Vector2)

#func _ready():
	#var min = Vector2(0, 0)
	#var max = Vector2(0, 0)
	#for v in $transition_area.polygon:
		#if v.x < min.x:
			#min.x = v.x
		#elif v.x > max.x:
			#max.x = v.x
			#
		#if v.y < min.y:
			#min.y = v.y
		#elif v.x > max.x:
			#max.y = v.y
			#
	#var width = max.x - min.x
	#var height = max.y - min.y
	#if width > height:
		#dirh = true
	#else:
		#dirh = false
		

func deactivate_transition():
	active_transition = false


func _on_body_entered(body: Node2D) -> void:
	print("transition ", name, " entered by ", body.name)
	if (active_transition && body.name == "player_character"):
		var p_offset: Vector2 = global_position - body.global_position
		#based on direction add tweak dist and flip offset of the corresponding value
		if dirh:
			p_offset.x = (p_offset.x) * -1
			p_offset.y *= tweak_dist
		else:
			p_offset.y = (p_offset.y) * -1
			p_offset.x *= tweak_dist
			
		room_transition.emit(parent, room_to, point_to_id, body, p_offset)


func _on_body_exited(body: Node2D) -> void:
	print("transition ", name, " exited by ", body.name)
	if (!locked && body.name == "player_character"):
		active_transition = true
