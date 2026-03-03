class_name GamepieceController extends Node

var focus: Gamepiece:
	set(value):
		if focus == value:
			return
		
		if focus != null:
			focus.turn_started.disconnect(_on_turn_started)
			focus.turn_ended.disconnect(_on_turn_ended)
		
		focus = value
		
		if focus != null:
			focus.turn_started.connect(_on_turn_started)
			focus.turn_ended.connect(_on_turn_ended)

var is_active: = false:
	set = set_is_active


func can_move_to_cell(cell: Vector2i) -> bool:
	if Map.gameboard.has_cell(cell) and Map.gamepieces.is_cell_empty(cell):
		return true
	
	# Check for distance here?
	return false


func set_is_active(value: bool) -> void:
	is_active = value


func _on_turn_started() -> void:
	is_active = true


func _on_turn_ended() -> void:
	is_active = false
