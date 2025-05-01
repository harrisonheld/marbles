extends Node

var marbles: Array[Node] = []
var current_player := 0
var shot_vector := Vector2.ZERO
var aiming := false
var aim_line := Line2D.new()



func _ready():
	add_child(aim_line)
	aim_line.width = 2
	aim_line.default_color = Color.YELLOW
	
	marbles = get_tree().get_nodes_in_group("marbles")
	aim_line = Line2D.new()
	add_child(aim_line)
	aim_line.width = 2
	aim_line.default_color = Color.YELLOW
	setup_turn()

func setup_turn():
	for i in range(marbles.size()):
		marbles[i].modulate = Color(1, 1, 1)  # Reset color
	marbles[current_player].modulate = Color(0.8, 1, 0.8)  # Highlight current
	aim_line.clear_points()
	print("Player", current_player + 1, ": Set your shot")

func next_turn():
	current_player += 1
	if current_player >= marbles.size():
		fire_all_shots()
	else:
		setup_turn()

func fire_all_shots():
	for m in marbles:
		m.fire_shot()
	current_player = 0
	setup_turn()

func _input(event):
	if marbles.size() == 0 or current_player >= marbles.size():
		return

	var marble := marbles[current_player]

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				aiming = true
			else:
				if aiming:
					aiming = false
					aim_line.clear_points()
					marble.prepare_shot(shot_vector)
					next_turn()

	elif event is InputEventMouseMotion and aiming:
		var aim_from = marble.global_position
		var aim_to = event.position
		shot_vector = aim_from.direction_to(aim_to) * 500

		aim_line.clear_points()
		aim_line.add_point(aim_from)
		aim_line.add_point(aim_to)
