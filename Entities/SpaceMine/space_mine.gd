extends Area2D

var mine_rotation_speed = PI/2

func _physics_process(delta: float) -> void:
	if is_queued_for_deletion():
		return

	rotation += delta * mine_rotation_speed
