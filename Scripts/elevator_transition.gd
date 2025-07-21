extends ColorRect

var finish_callback: Callable
var transition_callback: Callable
var transition_time: float = 0.75
var transition_time_black: float = 0.5
var time_elapsed: float = 0
var fade_stage: int = 0


func _process(delta: float) -> void:
	time_elapsed += delta
	match fade_stage:
		0:
			if time_elapsed < transition_time:
				self.color.a = time_elapsed / transition_time
			else:
				self.color.a = 1
				time_elapsed = 0
				transition_callback.call()
				fade_stage = 1
				
		1: #blackscween
			if time_elapsed >= transition_time_black:
				time_elapsed = 0
				fade_stage = 2
				finish_callback.call() #return control to player and remove triggerer from interactables
				
		2:
			if time_elapsed < transition_time:
				self.color.a = 1 - time_elapsed / transition_time
			else:
				queue_free()
	
