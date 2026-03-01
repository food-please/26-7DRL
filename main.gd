extends Node2D

@onready var root: Window = get_tree().root

func _ready() -> void:
	print("Main ready")
	
	Map.gameboard = $Gameboard
