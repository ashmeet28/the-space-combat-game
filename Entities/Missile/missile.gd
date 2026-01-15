extends Area2D

var missile_default_speed = 750/1.5

func _physics_process(delta: float) -> void:
	position +=  (Vector2.UP * missile_default_speed * delta).rotated(rotation)
