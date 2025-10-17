extends Node2D

func _ready() -> void:
	var spaceship = preload("res://Entities/Spaceship/spaceship.tscn").instantiate()
	spaceship.position = Vector2(1920,1080)
	add_child(spaceship)
