extends Area2D

var ROTATION_SPEED = PI
var DEFAULT_SPEED = 750
var controller_input_map = []

func _physics_process(delta: float) -> void:
	if len(controller_input_map) == 0:
		return

	var jv = Input.get_vector(controller_input_map[0],
	controller_input_map[1],
	controller_input_map[2],
	controller_input_map[3])
	
	if (jv.length() > 0): 
		var d =  Vector2.UP.rotated(rotation).cross(jv.normalized())
		if (d > 0.001):
			rotation += ROTATION_SPEED * delta
		if (d < -0.001):
			rotation -= ROTATION_SPEED * delta
			
	position +=  (Vector2.UP * DEFAULT_SPEED * delta).rotated(rotation)
	
	for a in controller_input_map:
		if Input.is_action_just_pressed(a):
			print(a)
