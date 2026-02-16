extends Area2D

var missile_default_speed = 750*1.25
var missile_default_rotation_speed = PI/2
var missile_target

var PLAYGROUND_WIDTH = 3840
var PLAYGROUND_HEIGHT = 2160

var PLAYGROUND_OUT_OF_AREA_MARGIN = 1000

func queue_free_if_out_of_playground():
	if ((position.x > PLAYGROUND_WIDTH + PLAYGROUND_OUT_OF_AREA_MARGIN) or
		(position.y > PLAYGROUND_HEIGHT + PLAYGROUND_OUT_OF_AREA_MARGIN) or 
		(position.x < -PLAYGROUND_OUT_OF_AREA_MARGIN) or 
		(position.y < -PLAYGROUND_OUT_OF_AREA_MARGIN)):
		queue_free()

func _physics_process(delta: float) -> void:
	if is_queued_for_deletion():
		return

	if is_instance_valid(missile_target) && missile_target.is_in_group("Spaceship"):
		var tv = position.direction_to(missile_target.position)
		var d =  Vector2.UP.rotated(rotation).cross(tv.normalized())
		var s = missile_default_rotation_speed
		
		if abs(d) < 0.05:
			s = s/16
		if (d >= 0):
			rotation += s * delta
		else:
			rotation -= s * delta
	else:
		var possible_target =  $RayCast2D.get_collider()
		if is_instance_valid(possible_target) && possible_target.is_in_group("Spaceship"):
			missile_target = possible_target

	position +=  Vector2.UP.rotated(rotation) * missile_default_speed * delta
	queue_free_if_out_of_playground()
