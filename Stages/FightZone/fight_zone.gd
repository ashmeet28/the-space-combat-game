extends Node2D

func _ready() -> void:
	var spaceship = preload(
		"res://Entities/Spaceship/spaceship.tscn").instantiate()
	spaceship.position = Vector2(1920,1080)
	add_child(spaceship)
	
	var spaceship_trail_1 = preload(
		"res://Entities/SpaceshipTrail/spaceship_trail.tscn").instantiate()
	spaceship_trail_1.spaceship_instance_id = spaceship.get_instance_id()
	spaceship_trail_1.spaceship_engine = 0
	spaceship_trail_1.default_color = Color(0,255,255,1)
	add_child(spaceship_trail_1)
	
	var spaceship_trail_2 = preload(
		"res://Entities/SpaceshipTrail/spaceship_trail.tscn").instantiate()
	spaceship_trail_2.spaceship_instance_id = spaceship.get_instance_id()
	spaceship_trail_2.spaceship_engine = 1
	spaceship_trail_2.default_color = Color(0,255,255,1)
	
	add_child(spaceship_trail_2)
	
