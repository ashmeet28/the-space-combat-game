extends Area2D

var bullet_default_speed = 1500

func _physics_process(delta: float) -> void:
	position +=  (Vector2.UP * bullet_default_speed * delta).rotated(rotation)
