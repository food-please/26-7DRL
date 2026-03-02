extends Node2D

@onready var root: Window = get_tree().root

@onready var gameboard: = $Gameboard  as Gameboard
@onready var gamepieces: = $Gameboard/Gamepieces as GamepieceRegistry

var focus: Gamepiece:
	set(value):
		focus = value
		print("\n%s takes a turn!"  % focus.name)
		print(gamepieces)

func _ready() -> void:
	print("Main ready")
	Map.setup(gamepieces, gameboard)
	
	await get_tree().process_frame
	
	print(Map.gamepieces)
	
	focus = Map.gamepieces.get_next_actor()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		focus.actor.charge -= 1.0
		focus = Map.gamepieces.get_next_actor()
