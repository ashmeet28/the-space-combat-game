extends Area2D

var ROTATION_SPEED = PI
var DEFAULT_SPEED = 750

func _physics_process(delta: float) -> void:
	var jv = Input.get_vector("JLD0","JRD0","JUD0","JDD0")
	if (jv.length() > 0): 
		var d =  Vector2.UP.rotated(rotation).cross(jv.normalized())
		if (d > 0.001):
			rotation += ROTATION_SPEED * delta
		if (d < -0.001):
			rotation -= ROTATION_SPEED * delta
			
	position +=  (Vector2.UP * DEFAULT_SPEED * delta).rotated(rotation)
