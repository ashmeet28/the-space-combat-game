extends Node2D

func _physics_process(_delta: float) -> void:
	get_tree().change_scene_to_file("res://Stages/Playground/playground.tscn")
