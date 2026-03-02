@tool
@icon("res://gamepieces/icon_gamepiece.png")
class_name Gamepiece extends Node2D

signal moved(old_cell: Vector2i)

@export var character: Character:
	set(value):
		if value == character:
			return
		
		character = value
		
		if not is_inside_tree():
			await ready
		
		print("Set character details!")
		if character == null:
			sprite.texture = null
			sprite.modulate = Color.WHITE
		
		else:
			sprite.texture = character.texture
			sprite.modulate = character.colour

var cell: Vector2i = Constants.INVALID_CELL:
	set(value):
		if Engine.is_editor_hint() or cell == value:
			return
		
		var old_cell: = cell
		cell = value
		
		if not is_inside_tree():
			await ready
		
		position = Map.gameboard.cell_to_px(cell)
		moved.emit(old_cell)

@onready var bg: ColorRect = $Background
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	bg.show()
	bg.color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color")
	
	if Map.gameboard == null:
		await Map.references_set
	
	cell = Map.gameboard.px_to_cell(position)
	position = Map.gameboard.cell_to_px(cell)
	print("Moved pos to ", position)
	
	if Map.gamepieces.register(self, cell) == false:
		queue_free()


#func move(direction: Directions.Points) -> bool:
	#var offset: Vector2i = Directions.OFFSETS.get(direction)
	#var new_cell: = cell + offset
	#
	#cell = new_cell
	#
	#return true



func _to_string() -> String:
	return "Gamepiece: %s" % name
