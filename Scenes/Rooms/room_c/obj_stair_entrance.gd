extends Object_Interactable

@export var quip: String
var outline_control: Panel
var bark_occured: bool = false


func _ready():
	outline_control = $Outline
	outline_control.hide()
	z_index = int(position.y)


##Default interaction is to delete and set the attached flag
func on_interact(player: CharacterBody2D):
	print("Interact with item '", self, "'")
	if bark_occured:
		player.remove_interactable(self)
		Global.current_ending = Global.Ending.STAIRS
		Global.loop_finish()
	else:
		print("I'm not sure that's a great idea...")
		bark_occured = true


##Default select behavior is to highlight
func set_selected():
	outline_control.show()


##Default deselect behavior is to remove highlight
func set_unselected():
	outline_control.hide()


##Contains the 
func _physics_process(_delta: float) -> void:
	pass
