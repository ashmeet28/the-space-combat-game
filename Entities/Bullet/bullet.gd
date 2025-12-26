extends Area2D

var DEFAULT_SPEED = 1500

func _physics_process(delta: float) -> void:
	position +=  (Vector2.UP * DEFAULT_SPEED * delta).rotated(rotation)
