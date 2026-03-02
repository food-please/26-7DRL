@icon("res://gamepieces/icon_turn_queue.png")
class_name GamepieceRegistry extends Node

# Multiple actors may finish 'charging' on a given update tick, therefore I'll store them in order.
var _charged_actors: Array[Gamepiece] = []

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
	
	gamepiece.actor.charged.connect(_on_actor_charged.bind(gamepiece))
	gamepiece.moved.connect(_on_gamepiece_moved.bind(gamepiece))
	
	# We want to know when the gamepiece leaves the scene tree, as it is no longer on the gameboard.
	# This probably means that the gamepiece has been freed.
	gamepiece.tree_exiting.connect(_on_gamepiece_tree_exiting.bind(gamepiece))
	
	_gamepieces[cell] = gamepiece
	print_debug("Registered gamepiece %s at %s." % [gamepiece.name, cell])
	return true


## I'm going to simulate the next several turns to get a list of actors, in order.
#func tick() -> void:
	#for gp: Gamepiece in get_children():
		#gp.actor.tick()


func get_next_actor() -> Gamepiece:
	var next_actor: Gamepiece = null
	while next_actor == null:
		if _gamepieces.is_empty():
			break
		
		# First, check to see if there are any Gamepieces lingering in the charged queue.
		while !_charged_actors.is_empty():
			next_actor = _charged_actors.pop_front()
			if next_actor != null and is_instance_valid(next_actor):
				break
		
		# There are no charged actors waiting. Running a game "tick" may make some actors ready.
		if next_actor == null:
			for gp: Gamepiece in get_children():
				gp.actor.tick()
	
	return next_actor


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


func _on_actor_charged(gp: Gamepiece) -> void:
	_charged_actors.append(gp)


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


func _sort_actors(a: Actor, b: Actor) -> bool:
	if is_equal_approx(a.charge, b.charge):
		return b.charge_rate > a.charge_rate
	return a.charge < b.charge


func _to_string() -> String:
	var msg: = "\nGamepieceRegistry:"
	for entry in _gamepieces:
		msg += ("\n%s %s" % [entry, str(_gamepieces[entry])])
	return msg
