extends Area2D

var mine_rotation_speed = PI/3

func _physics_process(delta: float) -> void:
	if is_queued_for_deletion():
		return

	rotation += delta * mine_rotation_speed
	
	$Sprite2D2.scale += Vector2(15, 15) * delta
	$Sprite2D2.scale = $Sprite2D2.scale.min(Vector2(1, 1))

	for a in get_overlapping_areas():
		if is_queued_for_deletion():
			break
		if a.is_queued_for_deletion():
			continue

		if a.is_in_group("Missile"):
			a.queue_free()
			queue_free()
