extends Node2D

var spaceship_instance_id
var bullet_last_fired = 0

func _ready() -> void:
	var spaceship = preload(
		"res://Entities/Spaceship/spaceship.tscn").instantiate()
	spaceship.position = Vector2(1920, 1080)
	spaceship_instance_id = spaceship.get_instance_id()
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
	
func _physics_process(_delta: float) -> void:
	if Input.is_joy_button_pressed(0,0 as JoyButton):
		if Time.get_ticks_msec() < bullet_last_fired + 100:
			return
		bullet_last_fired = Time.get_ticks_msec()
		var bullet = preload("res://Entities/Bullet/bullet.tscn").instantiate()
		bullet.position =  (instance_from_id(spaceship_instance_id).position + 
		Vector2(0, -65).rotated(
			instance_from_id(spaceship_instance_id).rotation))
		bullet.rotation = instance_from_id(spaceship_instance_id).rotation
		add_child.call_deferred(bullet)
