extends Node2D

var controller_inputs = [
	["JA0LD0","JA0RD0","JA1UD0","JA1DD0","JB0D0",
	"JB0D0","JB1D0","JB2D0","JB3D0",
	"JB4D0","JB5D0","JB6D0","JB7D0",
	"JB8D0","JB9D0","JB10D0","JB11D0",
	"JB12D0","JB13D0","JB14D0","JB15D0",
	"JB16D0","JB17D0","JB18D0","JB19D0",
	"JB20D0"]]

func _ready() -> void:
	var spaceship = preload(
		"res://Entities/Spaceship/spaceship.tscn").instantiate()
	spaceship.position = Vector2(1920,1080)
	spaceship.controller_input_map = controller_inputs[0]
	add_child.call_deferred(spaceship)
	
	var spaceship_trail_1 = preload(
		"res://Entities/SpaceshipTrail/spaceship_trail.tscn").instantiate()
	spaceship_trail_1.spaceship_instance_id = spaceship.get_instance_id()
	spaceship_trail_1.spaceship_engine = 0
	spaceship_trail_1.default_color = Color(0,255,255,1)
	add_child.call_deferred(spaceship_trail_1)
	
	var spaceship_trail_2 = preload(
		"res://Entities/SpaceshipTrail/spaceship_trail.tscn").instantiate()
	spaceship_trail_2.spaceship_instance_id = spaceship.get_instance_id()
	spaceship_trail_2.spaceship_engine = 1
	spaceship_trail_2.default_color = Color(0,255,255,1)
	
	add_child.call_deferred(spaceship_trail_2)
	
