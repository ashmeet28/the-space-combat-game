extends Area2D

var bullet_default_speed = 750*3

var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var PLAYGROUND_OUT_OF_AREA_MARGIN = 1000

func queue_free_if_out_of_playground():
	if ((position.x > PLAYGROUND_WIDTH + PLAYGROUND_OUT_OF_AREA_MARGIN) or
		(position.y > PLAYGROUND_HEIGHT + PLAYGROUND_OUT_OF_AREA_MARGIN) or 
		(position.x < -PLAYGROUND_OUT_OF_AREA_MARGIN) or 
		(position.y < -PLAYGROUND_OUT_OF_AREA_MARGIN)):
		queue_free()

func _physics_process(delta: float) -> void:
	if is_queued_for_deletion():
		return

	position +=  Vector2.UP.rotated(rotation) * bullet_default_speed * delta
	
	for a in get_overlapping_areas():
		if is_queued_for_deletion():
			break
		if a.is_queued_for_deletion():
			continue

		if a.is_in_group("Bullet"):
			a.queue_free()
			queue_free()
		elif a.is_in_group("SpaceMine"):
			a.queue_free()
			queue_free()

	queue_free_if_out_of_playground()
