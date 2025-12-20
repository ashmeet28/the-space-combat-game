extends Area2D

var ROTATION_SPEED = PI
var DEFAULT_SPEED = 750
var controller_input_map = {}

func joy_axis_apply_deadzone(v:float, d:float)-> float:
	if abs(v) >= d:
		return v
	else:
		return 0.0

func _physics_process(delta: float) -> void:
	var jv = Vector2(
		joy_axis_apply_deadzone(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), 0.2),
		joy_axis_apply_deadzone(Input.get_joy_axis(0, JOY_AXIS_LEFT_Y), 0.2))

	if (jv.length() > 0.2):
		var d =  Vector2.UP.rotated(rotation).cross(jv.normalized())
		if (d > 0.001):
			rotation += ROTATION_SPEED * delta
		if (d < -0.001):
			rotation -= ROTATION_SPEED * delta
			
	position +=  (Vector2.UP * DEFAULT_SPEED * delta).rotated(rotation)
