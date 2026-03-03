extends GamepieceController


func _ready() -> void:
	focus = get_parent() as Gamepiece
	assert(focus != null, "WanderController must be child of a gamepiece!")


func _on_turn_started() -> void:
	super._on_turn_started()
	wander.call_deferred()


func wander() -> void:
	var adjacent_cells: Array[Vector2i] = []
	for neighbour in Directions.OFFSETS.keys():
		var cell: Vector2i = focus.cell + Directions.OFFSETS[neighbour]
		if can_move_to_cell(cell):
			adjacent_cells.append(cell)
	
	if not adjacent_cells.is_empty():
		var chosen_cell: Vector2i = adjacent_cells.pick_random()
		
		focus.cell = chosen_cell
		focus.position = Map.gameboard.cell_to_px(chosen_cell)
	
	focus.end_turn.call_deferred(1.0)
