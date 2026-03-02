@icon("res://gamepieces/icon_turn_queue.png")
class_name GamepieceRegistry extends Node

# Store all registered gamepeices by the cell they occupy.
var _gamepieces: Dictionary[Vector2i, Gamepiece] = {}


func register(gamepiece: Gamepiece, cell: Vector2i) -> bool:
	# Don't register a gamepiece if it's cell is already occupied...
	if _gamepieces.has(cell):
		push_warning("GPRegistry failed to register %s at cell %s. It is already occupied!" 
			% [gamepiece.name, str(cell)])
		return false
	
	#...or if it has already been registered, for some reason.
	if gamepiece in _gamepieces.values():
		push_warning("GPRegistry failed to register %s at cell %s. It is already been registered!" 
			% [gamepiece.name, str(cell)])
		return false
	
	gamepiece.moved.connect(_on_gamepiece_moved.bind(gamepiece))
	
	# We want to know when the gamepiece leaves the scene tree, as it is no longer on the gameboard.
	# This probably means that the gamepiece has been freed.
	gamepiece.tree_exiting.connect(_on_gamepiece_tree_exiting.bind(gamepiece))
	
	_gamepieces[cell] = gamepiece
	print_debug("Registered gamepiece %s at %s." % [gamepiece.name, cell])
	return true


## Return the gamepiece, if any,that is found at a given cell.
func get_gamepiece(cell: Vector2i) -> Gamepiece:
	return _gamepieces.get(cell) as Gamepiece


## Return the gamepiece, if any, that has a given name.
func get_gamepiece_by_name(gp_name: String) -> Gamepiece:
	return get_node_or_null(gp_name) as Gamepiece
	#for gp: Gamepiece in _gamepieces.values():
		#if gp.name == gp_name:
			#return gp
	#return null


## Return the cell occupied by a given gamepiece.
func get_cell(gp: Gamepiece) -> Vector2i:
	var cell = _gamepieces.find_key(gp) as Vector2i
	if _gamepieces.has(cell):
		return cell
	return Constants.INVALID_CELL


func get_occupied_cells() -> Array[Vector2i]:
	return _gamepieces.keys()


func get_gamepieces() -> Array[Gamepiece]:
	return _gamepieces.values()


func _on_gamepiece_moved(old_cell: Vector2i, gp: Gamepiece) -> void:
	if old_cell == Constants.INVALID_CELL:
		return
	
	_gamepieces.erase(old_cell)
	if _gamepieces.has(gp.cell):
		push_warning("GPRegistry cannot update %s's cell to %s." % [gp.name, str(gp.cell)],
			"The cell is occupied.")
		gp.cell = old_cell
	
	else:
		_gamepieces[gp.cell] = gp


# Remove all traces of the gamepiece from the registry.
func _on_gamepiece_tree_exiting(gp: Gamepiece) -> void:
	var cell = _gamepieces.find_key(gp)
	if _gamepieces.has(cell):
		_gamepieces.erase(cell)
	
	#if cell != null:
		#Events.gamepiece_exiting_tree.emit(gp, cell)


func _to_string() -> String:
	var msg: = "\nGamepieceRegistry:"
	for entry in _gamepieces:
		msg += ("\n%s %s" % [entry, str(_gamepieces[entry])])
	return msg
