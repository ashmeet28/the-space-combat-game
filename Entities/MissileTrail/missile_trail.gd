extends Line2D

var missile

var missile_trail_offset = Vector2(0, 60)
var POINT_LIFETIME = 100

var points_tracked: Array[Vector2] =[]
var points_timestamp: Array[int] = []

func _ready() -> void:
	if is_instance_valid(missile):
		default_color = Color(255, 0, 0, 1)

func _physics_process(_delta: float) -> void:
	if !is_instance_valid(missile):
		queue_free()
		return
	
	if is_queued_for_deletion():
		return

	points_tracked.append(missile.position+missile_trail_offset.rotated(missile.rotation))

	points_timestamp.append(Time.get_ticks_msec())

	if points_timestamp[0] + POINT_LIFETIME < Time.get_ticks_msec():
		points_timestamp.pop_front()
		points_tracked.pop_front()

	clear_points()
	for p in points_tracked:
		add_point(p)
