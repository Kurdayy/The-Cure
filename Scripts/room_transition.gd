extends Area2D

@export var room_to: String = "room_lab"
@export var point_to_id: int = 0
@onready var parent: Room = get_parent().get_parent() #dirty foul creation

signal room_transition(room_from, room_to, point_to)

func _on_body_entered(body: Node2D) -> void:
	print("transition ", name, " entered by ", body.name)
	room_transition.emit(parent, room_to, point_to_id, body)
