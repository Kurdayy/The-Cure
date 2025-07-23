extends Object_Interactable

@onready var snd_point: AudioStreamPlayer2D = $snd
var first_interact: bool = true
var radio_on: bool = false


func on_interact(player: CharacterBody2D):
	print("Hello kitty is the best!")
	
	if first_interact:
		snd_point.play(0)
		radio_on = true
		first_interact = false
	
	elif radio_on:
		snd_point.volume_db = -60
		radio_on = false
	else:
		snd_point.volume_db = 0
		radio_on = true
