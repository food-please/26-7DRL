class_name Gameboard extends TileMapLayer

@onready var _walls: TileMapLayer = $Walls

## Returns true if coordinate is found as a GraphCell coordinate in the graph.
func has_cell(coordinate: Vector2i) -> bool:
	return get_cell_source_id(coordinate) != -1 and _walls.get_cell_source_id(coordinate) == -1


func cell_to_px(cell: Vector2i) -> Vector2:
	return map_to_local(cell)


func px_to_cell(coordinate: Vector2) -> Vector2i:
	return local_to_map(coordinate)
