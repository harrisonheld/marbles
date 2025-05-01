extends RigidBody2D

var shot_vector = Vector2.ZERO
var is_ready = false

func prepare_shot(vector):
	shot_vector = vector
	is_ready = true

func fire_shot():
	if is_ready:
		print(shot_vector)
		apply_impulse(shot_vector)
		is_ready = false
