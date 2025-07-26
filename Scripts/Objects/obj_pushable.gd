class_name PushableObject
extends RigidBody2D

func _physics_process(delta: float) -> void:
	z_index = int(position.y)
			
