extends Node2D

@onready var root: Window = get_tree().root

@onready var gameboard: = $Gameboard  as Gameboard
@onready var gamepieces: = $Gameboard/Gamepieces as GamepieceRegistry

@onready var player_panel: BasePanel = $UI/Border/CharacterStats

var focus: Gamepiece:
	set(value):
		focus = value
		print("\n%s takes a turn!"  % focus.name)
		print(gamepieces)

func _ready() -> void:
	Map.setup(gamepieces, gameboard)
	await get_tree().process_frame
	
	player_panel.background_color = Color(0.294, 0.502, 0.702, 1.0)
	player_panel.panel_color = Color(0.976, 0.961, 0.89, 1.0)
	player_panel.gp = $PlayerController.focus
	player_panel.setup()
	
	
	#$UI/Border/CharacterStats.setup(
		#Color(0.294, 0.502, 0.702, 1.0), 
		#Color(0.976, 0.961, 0.89, 1.0), 
		#"Player")

	gamepieces.next_turn.call_deferred()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		$PlayerController.focus.character.stats.hp -= 1
	
	elif event.is_action_released("ui_accept"):
		$PlayerController.focus.character.stats.hp += 1
