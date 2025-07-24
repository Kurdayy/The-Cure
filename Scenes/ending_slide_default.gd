extends ColorRect

var text_box: Label
var b_menu: Button
var b_reset: Button

var tween: Tween
const fade_in_time: float = 1
const text_delay: float = 0.5
const text_display_time: float = 10

func _ready():
	text_box = $EndingText
	b_menu = $B_Menu
	b_reset = $B_Reset
	
	self.color = Color( 1, 1, 1, 0)
	text_box.visible_characters = 0
	b_menu.hide()
	b_reset.hide()
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color.BLACK, fade_in_time)
	tween.tween_callback(b_menu.show).set_delay(text_delay)
	tween.tween_callback(b_reset.show)
	tween.tween_property(text_box, "visible_characters", text_box.get_total_character_count(), text_display_time)
	
	
func kill():
	if tween:
		tween.kill()
		
	queue_free()
	
	


func _on_b_menu_pressed() -> void:
	Global.spawn_main_menu()
	kill()



func _on_b_reset_pressed() -> void:
	kill()
	Global.reset()
