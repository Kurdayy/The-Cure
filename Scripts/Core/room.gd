@tool
class_name Room
extends Node2D

@export var camera_locked: bool = true
@export var room_height: int = 1080
@export var room_z_offset: int = 0
@export var power_flag: Global.Flag
var power_overlay
@onready var transitions: Array[Node] = $transitions.get_children(false)


func _ready():
	z_index = 0
	power_overlay = self.get_node("power_overlay")
	power_overlay.hide()
