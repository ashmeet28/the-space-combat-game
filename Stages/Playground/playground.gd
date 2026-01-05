extends Node2D

var SPACESHIPS_STARTING_MARGIN = 300
var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var spaceship_red_template = {
	"trail_color": Color(255, 0, 0, 1),
	"exists": false,
	"group": 1,
	"starting_position": Vector2(
		0+SPACESHIPS_STARTING_MARGIN,
		0+SPACESHIPS_STARTING_MARGIN),
	"starting_rotation": PI/2
}
var spaceship_yellow_template = {
	"trail_color": Color(255, 255, 0, 1),
	"exists": false,
	"group": 1,
	"starting_position": Vector2(
		0+SPACESHIPS_STARTING_MARGIN,
		PLAYGROUND_HEIGHT-SPACESHIPS_STARTING_MARGIN),
	"starting_rotation": PI/2
}
var spaceship_green_template = {
	"trail_color": Color(0, 255, 0, 1),
	"exists": false,
	"group": 2,
	"starting_position": Vector2(
		PLAYGROUND_WIDTH-SPACESHIPS_STARTING_MARGIN,
		0+SPACESHIPS_STARTING_MARGIN),
	"starting_rotation": PI/2 + PI
}
var spaceship_aqua_template = {
	"trail_color": Color(0, 255, 255, 1),
	"exists": false,
	"group": 2,
	"starting_position": Vector2(
		PLAYGROUND_WIDTH-SPACESHIPS_STARTING_MARGIN,
		PLAYGROUND_HEIGHT-SPACESHIPS_STARTING_MARGIN),
	"starting_rotation": PI/2 + PI
}


func spaceship_add_new(spaceship_template):
	var spaceship = preload("res://Entities/Spaceship/spaceship.tscn").instantiate()
	spaceship.position = spaceship_template.starting_position
	spaceship.rotation = spaceship_template.starting_rotation
	spaceship.ship_group = spaceship_template.group
	spaceship.ship_trail_color = spaceship_template.trail_color
	add_child.call_deferred(spaceship)
	return spaceship

func spaceship_trail_add_new(spaceship_engine, spaceship):
	var spaceship_trail = preload(
		"res://Entities/SpaceshipTrail/spaceship_trail.tscn").instantiate()
	spaceship_trail.spaceship = spaceship
	spaceship_trail.spaceship_engine = spaceship_engine
	add_child.call_deferred(spaceship_trail)
	return spaceship_trail

func spaceship_trails_add_new(spaceship_state):
	spaceship_trail_add_new(0, spaceship_state)
	spaceship_trail_add_new(1, spaceship_state)
	
# TODO: Handle multiple inputs and debug mode for single player debuging.
func _ready() -> void:
	var spaceship
	spaceship = spaceship_add_new(spaceship_red_template)
	spaceship_trails_add_new(spaceship)
	spaceship = spaceship_add_new(spaceship_green_template)
	spaceship_trails_add_new(spaceship)
	spaceship = spaceship_add_new(spaceship_aqua_template)
	spaceship_trails_add_new(spaceship)
	spaceship = spaceship_add_new(spaceship_yellow_template)
	spaceship_trails_add_new(spaceship)
	
#func _physics_process(_delta: float) -> void:
	#if Input.is_joy_button_pressed(0,0 as JoyButton):
		#if Time.get_ticks_msec() < bullet_last_fired + 100:
			#return
		#bullet_last_fired = Time.get_ticks_msec()
		#var bullet = preload("res://Entities/Bullet/bullet.tscn").instantiate()
		#bullet.position =  (instance_from_id(spaceship_instance_id).position + 
		#Vector2(0, -65).rotated(
			#instance_from_id(spaceship_instance_id).rotation))
		#bullet.rotation = instance_from_id(spaceship_instance_id).rotation
		#add_child.call_deferred(bullet)
