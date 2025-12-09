extends Line2D

var spaceship_instance_id:int
var spaceship_engine:int = 0
const SPACESHIP_TRAIL_OFFSET = Vector2(15, 60)

const POINT_LIFETIME:int = 100
var points_tracked: Array[Vector2] =[]
var points_timestamp: Array[int] = []
	
func _physics_process(delta: float) -> void:
	var final_trail_offset = SPACESHIP_TRAIL_OFFSET
	if spaceship_engine == 1:
		final_trail_offset.x = -final_trail_offset.x
		
	points_tracked.append(instance_from_id(spaceship_instance_id).position+
	final_trail_offset.rotated(
		instance_from_id(spaceship_instance_id).rotation))
	
	points_timestamp.append(Time.get_ticks_msec())
	
	if points_timestamp[0] + POINT_LIFETIME < Time.get_ticks_msec():
		points_timestamp.pop_front()
		points_tracked.pop_front()
	
	clear_points()
	for p in points_tracked:
		add_point(p)
