extends Node2D

class_name Object_Interactable

@export var interactable: bool = true
@export var max_interact_dist: float = 200
@export var max_outline_thickness: float = 7
@export var min_outline_thickness: float = 4
@export var outline_color: Color = "ffff57"
@export var flag_to_set: Global.Flag
@onready var delta_outline_thickness: float = max_outline_thickness - min_outline_thickness
@onready var SHADER: Shader = preload("res://Scripts/shaders/outline.gdshader")
var outline_ticks: int = 2000
var selected: bool = false

func _ready():
	material = ShaderMaterial.new()
	material.shader = SHADER
	material.set_shader_parameter("line_thickness", 0)
	material.set_shader_parameter("line_color", Vector4(outline_color.r, outline_color.g, outline_color.b, outline_color.a))
	material.resource_local_to_scene = true


##Default interaction is to delete and set the attached flag
func on_interact(player: CharacterBody2D):
	print("Interact with item '", self, "'")
	var diff: Vector2 = Global.player.global_position - global_position
	if diff.length() <= max_interact_dist:
		Global.set_flag(flag_to_set, true)
		player.remove_interactable(self)
		queue_free() #deletes node


##Default select behavior is to highlight
func set_selected():
	print("Selected interactable: ", self,)
	material.set_shader_parameter("line_thickness", max_outline_thickness)
	selected = true


##Default deselect behavior is to remove highlight
func set_unselected():
	print("Deselected interactable: ", self,)
	#var mat = self.material
	#if mat is ShaderMaterial:
	material.set_shader_parameter("line_thickness", 0)
	selected = false


##Contains the 
func _physics_process(delta: float) -> void:
	if !selected:
		return
		
	var tickrelative: float = Time.get_ticks_msec() % outline_ticks
	tickrelative = float(tickrelative) / outline_ticks
	var sinrelative = delta_outline_thickness * sin(tickrelative * 2 * PI)
	if sinrelative < 0:
		sinrelative = -sinrelative
	material.set_shader_parameter("line_thickness", min_outline_thickness + sinrelative)
	
