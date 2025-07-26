extends Node2D

class_name Object_Interactable

@export var interactable: bool = true
@export var flag_to_set: Global.Flag
@export var bark_enabled: bool = false
@export_group("Bark Properties")

@export var bark_text: String = ""
@export var bark_color: Color = Color(1, 1, 1, 1)
@export var bark_duration: float = 0.5
@export var bark_hover_duration: float = 2.5
@export var bark_hover_offset: float = 10
@export var bark_offset: Vector2 = Vector2(0, -64)

@export_group("Outline Properties")
@export var max_outline_thickness: float = 7
@export var min_outline_thickness: float = 4
@export var outline_color: Color = "ffff57"

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
	z_index = int(position.y)


##Default interaction is to flip flag and potentially spawn a bark
func on_interact(player: CharacterBody2D):
	Global.set_flag(flag_to_set, true)
	if bark_enabled:
		spawn_bark()
		#bark_enabled = false
		
		
func spawn_bark():
	var b = preload("res://Scenes/Prefabs/context_bark.tscn")
	var new_bark = b.instantiate()
	new_bark.bark_setup(bark_text, bark_color, bark_duration, bark_hover_duration, bark_hover_offset)
	
	new_bark.position += bark_offset
	self.add_child(new_bark)


##Default select behavior is to highlight
func set_selected():
	material.set_shader_parameter("line_thickness", max_outline_thickness)
	selected = true


##Default deselect behavior is to remove highlight
func set_unselected():
	material.set_shader_parameter("line_thickness", 0)
	selected = false


##Contains the 
func _physics_process(_delta: float) -> void:
	if !selected:
		return
		
	var tickrelative: float = Time.get_ticks_msec() % outline_ticks
	tickrelative = float(tickrelative) / outline_ticks
	var sinrelative = delta_outline_thickness * sin(tickrelative * 2 * PI)
	if sinrelative < 0:
		sinrelative = -sinrelative
	material.set_shader_parameter("line_thickness", min_outline_thickness + sinrelative)
	
