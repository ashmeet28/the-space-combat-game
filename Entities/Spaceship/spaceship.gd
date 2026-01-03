extends Area2D

var ROTATION_SPEED = PI
var DEFAULT_SPEED = 750
var controller_input_map = {
	"device": 0,
	"axis_x": JOY_AXIS_LEFT_X,
	"axis_y": JOY_AXIS_LEFT_Y
}

var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var RETURN_PLAYGROUND_MARGIN = 200

var is_returning_to_playground = false

var spaceship_state = {}

#func joy_axis_apply_deadzone(v:float, d:float)-> float:
	#if abs(v) >= d:
		#return v
	#else:
		#return 0.0

func handle_return_to_playground(delta: float):
	var playground_center = (Vector2(float(PLAYGROUND_WIDTH)/2, 
	float(PLAYGROUND_HEIGHT)/2))

	if (Vector2.UP.rotated(rotation).cross(
		(playground_center - position).normalized()) >= 0):
		rotation += ROTATION_SPEED * delta
	else:
		rotation -= ROTATION_SPEED * delta

func handle_controller_input(delta: float):
	var jv = Vector2(
		Input.get_joy_axis(controller_input_map.device, controller_input_map.axis_x),
		Input.get_joy_axis(controller_input_map.device, controller_input_map.axis_y))

	if (jv.length() > 0.2):
		var d =  Vector2.UP.rotated(rotation).cross(jv.normalized())
		if (d >= 0):
			rotation += ROTATION_SPEED * delta
		else:
			rotation -= ROTATION_SPEED * delta

func _physics_process(delta: float) -> void:
	if ((position.x > PLAYGROUND_WIDTH) or (position.y > PLAYGROUND_HEIGHT) or 
		(position.x < 0) or (position.y < 0)):
		is_returning_to_playground = true

	if is_returning_to_playground:
		handle_return_to_playground(delta)
		if ((position.x < PLAYGROUND_WIDTH - RETURN_PLAYGROUND_MARGIN) and
			(position.y < PLAYGROUND_HEIGHT -RETURN_PLAYGROUND_MARGIN) and
			(position.x > RETURN_PLAYGROUND_MARGIN) and
			(position.y > RETURN_PLAYGROUND_MARGIN)):
			is_returning_to_playground = false
	else:
		handle_controller_input(delta)

	position +=  (Vector2.UP * DEFAULT_SPEED * delta).rotated(rotation)
