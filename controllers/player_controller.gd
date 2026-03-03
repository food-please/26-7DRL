extends GamepieceController

@export var gp_container: Node
@export var gamepiece_scene: PackedScene
#@export var focus: Gamepiece
@export var player_character: Character
@export var player_start_position: Node2D

#var is_active: = false:
	#set(value):
		#is_active = value
		#print("Player controller is active? ", is_active)
		#set_process_unhandled_input(is_active)



func _ready() -> void:
	assert(gp_container != null, "PlayerController needs a reference to the Gamepiece parent!")
	assert(player_character != null, "PlayerController needs a Character to instantiate!")
	assert(player_start_position != null, "PlayerController needs a position for the player!")
	
	var new_gp: = gamepiece_scene.instantiate()
	new_gp.name = "Player"
	new_gp.character = player_character
	new_gp.position = player_start_position.position
	gp_container.add_child(new_gp)
	
	focus = new_gp
	assert(focus is Gamepiece, "PlayerController could not instantiate a Gamepiece from the " +
		"provided gamepiece_scene!")
	assert(focus != null, "PlayerController failed to create the player!")
	
	player_start_position.queue_free()


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
	
	#elif event.is_action_released("ui_accept"):
		#focus.end_turn.call_deferred(1.0)


func set_is_active(value: bool) -> void:
	super.set_is_active(value)
	set_process_unhandled_input(is_active)


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
			
			focus.end_turn.call_deferred(1.0)
		
		else:
			var occupant_stats: = occupant.character.stats
			var damage = focus.character.stats.attack - occupant_stats.defense
			print("Found something! Name: ", occupant.name, " Attack for %d points." % damage)
			
			occupant.take_hit(damage)
			focus.end_turn.call_deferred(1.0)
	
	else:
		pass # Bump?
	
	
	return true
