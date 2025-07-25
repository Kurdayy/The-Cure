class_name Transition
extends ColorRect

var direction: int = 1
var fade_time: float = 1
var fade_start_delay: float = 0
var fade_end_delay: float = 0.5

var callable: Callable = Callable()
var tween: Tween

func setup(callback: Callable = Callable(), dir: int = direction, ft: float = fade_time, fsd: float = fade_start_delay, fed:float = fade_end_delay):
	self.direction = dir
	self.fade_time = ft
	self.fade_start_delay = fsd
	self.fade_end_delay = fed
	self.callable = callback

func begin_transition():
	tween = get_tree().create_tween()	
	var alpha = 1
	if direction == 1:
		self.color = Color(0, 0, 0, 0)
		alpha = 1
	else:
		self.color = Color(0, 0, 0, 1)
		alpha = 0
	tween.tween_property(self, "color", Color(0, 0, 0, alpha), fade_time).set_delay(fade_start_delay)
	tween.tween_callback(end_transition).set_delay(fade_end_delay)
	
	
func end_transition():
	callable.call()
	queue_free()
