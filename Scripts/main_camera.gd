extends Camera2D

var camera_follow: bool = false
var v_width: int = 1920
var v_height: int = 1080
var char_height_offset: int = 500
var limit_hor: Vector2 = Vector2(0, 0)
var limit_ver: Vector2 = Vector2(0, 0)

@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player_character")

func _physics_process(delta: float) -> void:
	
	if !camera_follow:
		return
	var limit_len = limit_ver.y - limit_ver.x
	var prog = (player.position.y - limit_ver.y)
	var desired_offset = (char_height_offset *  (prog / limit_len)) #gradient/max * %
	position.x = clamp(player.position.x - (v_width / 2), limit_hor.x, limit_hor.y)
	position.y = clamp(player.position.y + desired_offset - (v_height / 2), limit_ver.x, limit_ver.y)
	
