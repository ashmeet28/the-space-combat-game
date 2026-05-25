extends Area2D

var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var spwaner_playground

func _ready() -> void:
	var r = $CollisionShape2D.shape.radius
	position = Vector2(Vector2i(
		randi_range(r, PLAYGROUND_WIDTH-r), 
		randi_range(r, PLAYGROUND_HEIGHT-r)))

func _physics_process(_delta: float) -> void:
	for a in get_overlapping_areas():
		if is_queued_for_deletion():
			break
		if a.is_queued_for_deletion():
			continue

		if (a.is_in_group("Spaceship") or a.is_in_group("Bullet") or 
		a.is_in_group("SpaceMine") or a.is_in_group("Missile")):
			queue_free()
	
	if is_queued_for_deletion():
		return
	
	var p = preload("res://Entities/BulletPickup/bullet_pickup.tscn").instantiate()
	p.position = position
	spwaner_playground.add_child(p)
	
	queue_free()
	
