extends Area2D

var ship_default_rotation_speed = PI
var ship_default_speed = 750

var ship_controller = {
	"device": 0,
	"axis_x": JOY_AXIS_LEFT_X,
	"axis_y": JOY_AXIS_LEFT_Y
}

var ship_trail_color = Color(255,255,255, 1)
var ship_group = 0

var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var PLAYGROUND_RETURN_MARGIN = 200

var ship_is_returning_to_playground = false


#func joy_axis_apply_deadzone(v:float, d:float)-> float:
	#if abs(v) >= d:
		#return v
	#else:
		#return 0.0

func handle_return_to_playground(delta: float):
	var playground_center = (Vector2(float(PLAYGROUND_WIDTH)/2, float(PLAYGROUND_HEIGHT)/2))

	if (Vector2.UP.rotated(rotation).cross((playground_center - position).normalized()) >= 0):
		rotation += ship_default_rotation_speed * delta
	else:
		rotation -= ship_default_rotation_speed * delta

func handle_controller_input(delta: float):
	var jv = Vector2(
		Input.get_joy_axis(ship_controller.device, ship_controller.axis_x),
		Input.get_joy_axis(ship_controller.device, ship_controller.axis_y))

	if (jv.length() > 0.2):
		var d =  Vector2.UP.rotated(rotation).cross(jv.normalized())
		if (d >= 0):
			rotation += ship_default_rotation_speed * delta
		else:
			rotation -= ship_default_rotation_speed * delta

func _physics_process(delta: float) -> void:
	if ((position.x > PLAYGROUND_WIDTH) or (position.y > PLAYGROUND_HEIGHT) or 
		(position.x < 0) or (position.y < 0)):
		ship_is_returning_to_playground = true

	if ship_is_returning_to_playground:
		handle_return_to_playground(delta)
		if ((position.x < PLAYGROUND_WIDTH - PLAYGROUND_RETURN_MARGIN) and
			(position.y < PLAYGROUND_HEIGHT -PLAYGROUND_RETURN_MARGIN) and
			(position.x > PLAYGROUND_RETURN_MARGIN) and
			(position.y > PLAYGROUND_RETURN_MARGIN)):
			ship_is_returning_to_playground = false
	else:
		handle_controller_input(delta)

	position +=  (Vector2.UP * ship_default_speed * delta).rotated(rotation)
