extends Node

@export var focus: Gamepiece


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("move_nw"):
		move(Directions.Points.NW)
	
	elif event.is_action_released("move_n"):
		move(Directions.Points.N)
	
	elif event.is_action_released("move_ne"):
		move(Directions.Points.NE)
	
	elif event.is_action_released("move_e"):
		move(Directions.Points.E)
	
	elif event.is_action_released("move_se"):
		move(Directions.Points.SE)
	
	elif event.is_action_released("move_s"):
		move(Directions.Points.S)
	
	elif event.is_action_released("move_sw"):
		move(Directions.Points.SW)
	
	elif event.is_action_released("move_w"):
		move(Directions.Points.W)


func move(direction: Directions.Points) -> bool:
	var offset: Vector2i = Directions.OFFSETS.get(direction)
	
	var gp_registry: = Map.gamepieces
	#var new_cell: = focus.cell + offset
	var new_cell: = gp_registry.get_cell(focus) + offset
	
	if Map.gameboard.has_cell(new_cell):
		if gp_registry.get_gamepiece(new_cell) == null:
			focus.cell = new_cell
			focus.position = Map.gameboard.cell_to_px(new_cell)
	
	else:
		pass # Bump?
	
	
	return true
