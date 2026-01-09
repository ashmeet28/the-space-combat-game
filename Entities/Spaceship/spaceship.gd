extends Area2D

var ship_default_rotation_speed = PI
var ship_default_speed = 750

var ship_rotation_speed_while_firing_bullets = PI/4

var ship_controller_is_connected= false
var ship_controller_device
var ship_controller_mapping

var ship_trail_color
var ship_group

var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var PLAYGROUND_RETURN_MARGIN = 200

var ship_is_returning_to_playground = false

var ship_playground
var ship_bullet_cooldown_time_left = 0.0
var ship_bullet_cooldown_time = 0.06

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
		Input.get_joy_axis(ship_controller_device, ship_controller_mapping.axis_x),
		Input.get_joy_axis(ship_controller_device, ship_controller_mapping.axis_y))
		
	if (jv.length() > 0.2):
		var d =  Vector2.UP.rotated(rotation).cross(jv.normalized())
		var s = ship_default_rotation_speed
		if ship_bullet_cooldown_time_left > 0:
			s = ship_rotation_speed_while_firing_bullets
		if (d >= 0):
			rotation += s * delta
		else:
			rotation -= s * delta

func playground_add_bullet(_delta: float):
	if ship_bullet_cooldown_time_left > 0:
		return
	var bullet = preload("res://Entities/Bullet/bullet.tscn").instantiate()
	bullet.position =  position + Vector2(0, -65).rotated(rotation)
	bullet.rotation =  rotation
	ship_playground.add_child.call_deferred(bullet)
	ship_bullet_cooldown_time_left = ship_bullet_cooldown_time

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
	elif ship_controller_is_connected:
		handle_controller_input(delta)
	position +=  (Vector2.UP * ship_default_speed * delta).rotated(rotation)
	
	if ship_bullet_cooldown_time_left > 0:
		ship_bullet_cooldown_time_left -= delta
	
	if ship_controller_is_connected:
		if Input.is_joy_button_pressed(ship_controller_device, 
			ship_controller_mapping["button_a"]):
			playground_add_bullet(delta)
		if Input.is_joy_button_pressed(ship_controller_device,
		 	ship_controller_mapping["button_back"]):
			get_tree().quit(0)
