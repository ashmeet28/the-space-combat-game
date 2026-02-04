extends Node2D

var SPACESHIP_STARTING_MARGIN = 300
var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var spaceship_red_template = {
	"trail_color": Color(255, 0, 0, 1),
	"starting_position": Vector2(
		0+SPACESHIP_STARTING_MARGIN,
		0+SPACESHIP_STARTING_MARGIN),
	"starting_rotation": PI/2
}
var spaceship_yellow_template = {
	"trail_color": Color(255, 255, 0, 1),
	"starting_position": Vector2(
		0+SPACESHIP_STARTING_MARGIN,
		PLAYGROUND_HEIGHT-SPACESHIP_STARTING_MARGIN),
	"starting_rotation": PI/2
}
var spaceship_green_template = {
	"trail_color": Color(0, 255, 0, 1),
	"starting_position": Vector2(
		PLAYGROUND_WIDTH-SPACESHIP_STARTING_MARGIN,
		0+SPACESHIP_STARTING_MARGIN),
	"starting_rotation": PI/2 + PI
}
var spaceship_aqua_template = {
	"trail_color": Color(0, 255, 255, 1),
	"starting_position": Vector2(
		PLAYGROUND_WIDTH-SPACESHIP_STARTING_MARGIN,
		PLAYGROUND_HEIGHT-SPACESHIP_STARTING_MARGIN),
	"starting_rotation": PI/2 + PI
}

var spaceship_red
var spaceship_yellow
var spaceship_green
var spaceship_aqua
var spaceships

func spaceship_add_new(spaceship_template):
	var spaceship = preload("res://Entities/Spaceship/spaceship.tscn").instantiate()
	spaceship.position = spaceship_template.starting_position
	spaceship.rotation = spaceship_template.starting_rotation
	spaceship.ship_trail_color = spaceship_template.trail_color
	spaceship.ship_playground = self
	add_child(spaceship)
	return spaceship

func spaceship_trail_add_new(spaceship_engine, spaceship):
	var spaceship_trail = preload(
		"res://Entities/SpaceshipTrail/spaceship_trail.tscn").instantiate()
	spaceship_trail.spaceship = spaceship
	spaceship_trail.spaceship_engine = spaceship_engine
	add_child(spaceship_trail)
	return spaceship_trail

func spaceship_trails_add_new(spaceship_state):
	spaceship_trail_add_new(1, spaceship_state)
	spaceship_trail_add_new(-1, spaceship_state)
	

func _ready() -> void:
	spaceship_red = spaceship_add_new(spaceship_red_template)
	spaceship_trails_add_new(spaceship_red)
	spaceship_yellow = spaceship_add_new(spaceship_yellow_template)
	spaceship_trails_add_new(spaceship_yellow)
	spaceship_green = spaceship_add_new(spaceship_green_template)
	spaceship_trails_add_new(spaceship_green)
	spaceship_aqua = spaceship_add_new(spaceship_aqua_template)
	spaceship_trails_add_new(spaceship_aqua)
	spaceships = [spaceship_red, spaceship_yellow, spaceship_green, spaceship_aqua]
	
func handle_debug_mode_input_spaceship_switching(_delta: float):
	var disconnect_spaceships_controller = func():
		for ship in spaceships:
			if not is_instance_valid(ship):
				continue
			ship.ship_controller_is_connected = false
			ship.ship_controller_device = null
			ship.ship_controller_mapping = null
	
	var connect_spaceship_controller = func(ship, device, controller_mapping):
		if not is_instance_valid(ship):
				return
		ship.ship_controller_is_connected = true
		ship.ship_controller_device = device
		ship.ship_controller_mapping = controller_mapping

	var dpad_spaceship_mapping = {
		"dpad_up": spaceship_red,
		"dpad_right": spaceship_green,
		"dpad_left" : spaceship_aqua,
		"dpad_down" : spaceship_yellow}

	for k in dpad_spaceship_mapping:
		var joy_device = 0
		if Input.is_joy_button_pressed(joy_device, GameSettings.controller_mapping[k]):
			disconnect_spaceships_controller.call()
			connect_spaceship_controller.call(
				dpad_spaceship_mapping[k], joy_device, GameSettings.controller_mapping)
		

func _physics_process(delta: float) -> void:
	if GameSettings.is_debug_mode_enabled:
		handle_debug_mode_input_spaceship_switching(delta)


# Overlapping areas collision connections:
# Spaceship
# Bullet
# SpaceMine
# Missile
