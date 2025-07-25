class_name ContextBark
extends Node2D

var bark_text: String = "Tuesdays really are the worst, aren't they?"
var bark_duration: float = 0.5
var bark_hover: float = 10
var bark_hover_duration: float = 2
var bark_color: Color = Color(1, 1, 1, 1)
var context_bark_text: Label
var tween: Tween

## Initialize bark attributes
func bark_setup(text: String, color: Color, duration: float, hover_duration:float, hover_height: float):
	bark_text = text
	bark_color = color
	bark_hover = hover_height
	bark_hover_duration = hover_duration
	bark_duration = duration
	

func _ready():
	global_scale = Vector2(1, 1)
	context_bark_text = $context_bark_text
	context_bark_text.text = bark_text
	context_bark_text["theme_override_colors/font_color"] = bark_color
	var col_to_alpha = Color(bark_color.r, bark_color.g, bark_color.b, 0)
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(position.x, position.y - bark_hover), bark_hover_duration)
	tween.tween_callback(queue_free).set_delay(bark_duration)
