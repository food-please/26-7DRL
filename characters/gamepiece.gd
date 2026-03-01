class_name Gamepiece extends Node2D

signal moved(old_cell: Vector2i)

var cell: Vector2i = Constants.INVALID_CELL:
	set(value):
		if cell == value:
			return
		
		if not is_inside_tree():
			await ready
		
		var old_cell: = cell
		cell = value
		position = Map.gameboard.cell_to_px(cell)
		moved.emit(old_cell)

@onready var bg: ColorRect = $Background


func _ready() -> void:
	bg.show()
	bg.color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color")
	
	print("GP ready!")
	if Map.gameboard == null:
		await Map.gameboard_set
	
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
