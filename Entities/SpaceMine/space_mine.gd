extends Area2D

var mine_rotation_speed = PI/3

func _physics_process(delta: float) -> void:
	if is_queued_for_deletion():
		return

	rotation += delta * mine_rotation_speed
	
	$Sprite2D2.scale += Vector2(15, 15) * delta
	$Sprite2D2.scale = $Sprite2D2.scale.min(Vector2(1, 1))
