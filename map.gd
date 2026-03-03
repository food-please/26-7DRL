extends Node

signal references_set

var gameboard: Gameboard = null
	#set(value):
		#if value != gameboard:
			#gameboard = value
			#gameboard_set.emit()

var gamepieces: GamepieceRegistry = null
	#get:
		#if gamepieces == null:
			#print("Build gamepiece registry.")
			#gamepieces = GamepieceRegistry.new()
		#return gamepieces


func _ready() -> void:
	print("MAp ready!")
	Events.playfield_freed.connect(reset)


func setup(gp_manager: GamepieceRegistry, gb: Gameboard) -> void:
	reset()
	
	gameboard = gb
	gamepieces = gp_manager
	
	RenderingServer.set_default_clear_color(gb.bg_color)
	references_set.emit()


func reset() -> void:
	gameboard = null
	gamepieces = null
