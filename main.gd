extends Node2D

@onready var root: Window = get_tree().root

@onready var gameboard: = $Gameboard  as Gameboard
@onready var gamepieces: = $Gameboard/Gamepieces as GamepieceRegistry

func _ready() -> void:
	print("Main ready")
	Map.setup(gamepieces, gameboard)
	
	await get_tree().process_frame
	
	print(Map.gamepieces)
