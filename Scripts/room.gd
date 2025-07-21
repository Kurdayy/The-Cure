@tool
class_name Room
extends Node2D

@export var camera_locked: bool = true
@export var room_height: int = 1080
@onready var transitions: Array[Node] = $transitions.get_children(false)


func _ready():
	z_index = position.y
