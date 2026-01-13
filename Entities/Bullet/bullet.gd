extends Area2D

var bullet_default_speed = 750*3

var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var PLAYGROUND_OUT_OF_AREA_MARGIN = 1000

func _physics_process(delta: float) -> void:
	if is_queued_for_deletion():
		return

	position +=  (Vector2.UP * bullet_default_speed * delta).rotated(rotation)

	if ((position.x > PLAYGROUND_WIDTH + PLAYGROUND_OUT_OF_AREA_MARGIN) or
		(position.y > PLAYGROUND_HEIGHT + PLAYGROUND_OUT_OF_AREA_MARGIN) or 
		(position.x < -PLAYGROUND_OUT_OF_AREA_MARGIN) or 
		(position.y < -PLAYGROUND_OUT_OF_AREA_MARGIN)):
		queue_free()
	
	for a in get_overlapping_areas():
		if a.is_in_group("SpaceMine"):
			a.queue_free()
			queue_free()
