extends Area2D

func _physics_process(delta: float) -> void:
	var jv =Input.get_vector("JLD0","JRD0","JUD0","JDD0")
	if (jv.length() > 0.3): 
		var d =  Vector2(0,-1).rotated(rotation).cross(jv.normalized())
		if (d > 0.1):
			rotation += PI * delta
		if (d < 0.1):
			rotation -= PI * delta
	position +=  Vector2(0,-750).rotated(rotation) * delta
