extends Area2D

var bullet_default_speed = 1500

var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var PLAYGROUND_OUT_OF_AREA_MARGIN = 1000

func _physics_process(delta: float) -> void:
	position +=  (Vector2.UP * bullet_default_speed * delta).rotated(rotation)

	if ((position.x > PLAYGROUND_WIDTH + PLAYGROUND_OUT_OF_AREA_MARGIN) or
		(position.y > PLAYGROUND_HEIGHT + PLAYGROUND_OUT_OF_AREA_MARGIN) or 
		(position.x < -PLAYGROUND_OUT_OF_AREA_MARGIN) or 
		(position.y < -PLAYGROUND_OUT_OF_AREA_MARGIN)):
		queue_free()
