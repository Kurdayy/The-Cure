@tool
class_name Room
extends Node2D

@export var camera_locked: bool = true
@export var room_height: int = 1080
@export var room_z_offset: int = 0
@onready var transitions: Array[Node] = $transitions.get_children(false)


func _ready():
	z_index = 0
