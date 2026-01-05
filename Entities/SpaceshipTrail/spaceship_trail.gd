extends Line2D

var spaceship
var spaceship_engine

var SPACESHIP_TRAIL_OFFSET = Vector2(15, 60)
var POINT_LIFETIME = 100

var points_tracked: Array[Vector2] =[]
var points_timestamp: Array[int] = []

func _ready() -> void:
	default_color = spaceship.ship_trail_color

func _physics_process(_delta: float) -> void:
	var final_trail_offset = SPACESHIP_TRAIL_OFFSET
	if spaceship_engine == 1:
		final_trail_offset.x = -final_trail_offset.x

	points_tracked.append(spaceship.position+
	final_trail_offset.rotated(spaceship.rotation))

	points_timestamp.append(Time.get_ticks_msec())

	if points_timestamp[0] + POINT_LIFETIME < Time.get_ticks_msec():
		points_timestamp.pop_front()
		points_tracked.pop_front()

	clear_points()
	for p in points_tracked:
		add_point(p)
