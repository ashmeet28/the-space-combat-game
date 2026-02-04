extends Area2D

var ship_default_rotation_speed = PI
var ship_default_speed = 750

var ship_rotation_speed_while_firing_bullets = PI/6

var ship_controller_is_connected= false
var ship_controller_device
var ship_controller_mapping

var ship_trail_color

var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var PLAYGROUND_RETURN_MARGIN = 200

var ship_is_returning_to_playground = false

var ship_playground
var ship_bullet_cooldown_time_left = 0.0
var ship_bullet_cooldown_time = 0.03 # Bullet length / (Bullet speed - Spaceship speed)

var ship_space_mine_cooldown_time_left = 0.0
var ship_space_mine_cooldown_time = 0.3

var ship_missile_is_in_chamber = false
var ship_missile_cooldown_time_left = 0.0
var ship_missile_cooldown_time = 0.4
var ship_missile_next_launcher = 1

var ship_starting_health = 1000
var ship_health = ship_starting_health


func handle_return_to_playground(delta: float):
	var playground_center = (Vector2(float(PLAYGROUND_WIDTH)/2, float(PLAYGROUND_HEIGHT)/2))

	if (Vector2.UP.rotated(rotation).cross((playground_center - position).normalized()) >= 0):
		rotation += ship_default_rotation_speed * delta
	else:
		rotation -= ship_default_rotation_speed * delta


func handle_controller_joy_axis_input(delta: float):
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
	ship_playground.add_child(bullet)
	ship_bullet_cooldown_time_left = ship_bullet_cooldown_time

func playground_add_space_mine(_delta: float):
	if ship_space_mine_cooldown_time_left > 0:
		return
	var space_mine = preload("res://Entities/SpaceMine/space_mine.tscn").instantiate()
	space_mine.position = position + Vector2(0, 100).rotated(rotation)
	space_mine.rotation = rotation
	ship_playground.add_child(space_mine)
	ship_space_mine_cooldown_time_left = ship_space_mine_cooldown_time
	
func playground_add_missile(_delta: float):
	if not ship_missile_is_in_chamber or ship_missile_cooldown_time_left > 0:
		return
	var missile = preload("res://Entities/Missile/missile.tscn").instantiate()
	missile.position = position + Vector2(25 * ship_missile_next_launcher, -80).rotated(rotation)
	ship_missile_next_launcher = -ship_missile_next_launcher
	missile.rotation = rotation
	ship_playground.add_child(missile)
	ship_missile_is_in_chamber = false
	var missile_trail = preload("res://Entities/MissileTrail/missile_trail.tscn").instantiate()
	missile_trail.missile = missile
	ship_playground.add_child(missile_trail)
	ship_missile_cooldown_time_left = ship_missile_cooldown_time


func _physics_process(delta: float) -> void:
	if is_queued_for_deletion():
		return

	if ((position.x > PLAYGROUND_WIDTH) or (position.y > PLAYGROUND_HEIGHT) or 
		(position.x < 0) or (position.y < 0)):
		ship_is_returning_to_playground = true

	if ship_is_returning_to_playground:
		handle_return_to_playground(delta)
		if ((position.x < PLAYGROUND_WIDTH - PLAYGROUND_RETURN_MARGIN) and
			(position.y < PLAYGROUND_HEIGHT - PLAYGROUND_RETURN_MARGIN) and
			(position.x > PLAYGROUND_RETURN_MARGIN) and
			(position.y > PLAYGROUND_RETURN_MARGIN)):
			ship_is_returning_to_playground = false
	elif ship_controller_is_connected:
		handle_controller_joy_axis_input(delta)
		
	position +=  Vector2.UP.rotated(rotation) * ship_default_speed * delta
	
	if ship_bullet_cooldown_time_left > 0:
		ship_bullet_cooldown_time_left -= delta
	if ship_space_mine_cooldown_time_left > 0:
		ship_space_mine_cooldown_time_left -= delta
	if ship_missile_cooldown_time_left > 0:
		ship_missile_cooldown_time_left -= delta
	
	if ship_controller_is_connected:
		if Input.is_joy_button_pressed(ship_controller_device,
		 	ship_controller_mapping["button_back"]):
			get_tree().quit(0)

		if not ship_is_returning_to_playground:
			if Input.is_joy_button_pressed(ship_controller_device, 
				ship_controller_mapping["button_a"]):
				playground_add_bullet(delta)
			elif Input.is_joy_button_pressed(ship_controller_device, 
				ship_controller_mapping["button_b"]):
				playground_add_space_mine(delta)
			elif Input.is_joy_button_pressed(ship_controller_device, 
				ship_controller_mapping["button_x"]):
				playground_add_missile(delta)

		if not Input.is_joy_button_pressed(ship_controller_device, 
				ship_controller_mapping["button_x"]):
				ship_missile_is_in_chamber = true

	for a in get_overlapping_areas():
		if a.is_queued_for_deletion():
			continue

		if a.is_in_group("Bullet"):
			a.queue_free()
			ship_health -= 100
		elif a.is_in_group("SpaceMine"):
			a.queue_free()
			ship_health -= 500
		elif a.is_in_group("Missile"):
			a.queue_free()
			ship_health -= 500
	
	if ship_health <= 0:
		queue_free()
