extends Node

@export var gp_container: Node
@export var gamepiece_scene: PackedScene
#@export var focus: Gamepiece
@export var player_character: Character
@export var player_start_position: Node2D

var focus: Gamepiece


func _ready() -> void:
	assert(gp_container != null, "PlayerController needs a reference to the Gamepiece parent!")
	assert(player_character != null, "PlayerController needs a Character to instantiate!")
	assert(player_start_position != null, "PlayerController needs a position for the player!")
	
	focus = gamepiece_scene.instantiate()
	focus.name = "Player"
	focus.character = player_character
	focus.position = player_start_position.position
	gp_container.add_child(focus)
	assert(focus is Gamepiece, "PlayerController could not instantiate a Gamepiece from the " +
		"provided gamepiece_scene!")
	assert(focus != null, "PlayerController failed to create the player!")


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
		var occupant: = gp_registry.get_gamepiece(new_cell)
		if occupant == null:
			focus.cell = new_cell
			focus.position = Map.gameboard.cell_to_px(new_cell)
		
		else:
			print("Found something! Name: ", occupant.name)
	
	else:
		pass # Bump?
	
	
	return true
