@tool
class_name BasePanel extends PanelContainer

@export var background_color: Color:
	set(value):
		background_color = value
		
		if not is_inside_tree():
			await ready
		
		bg.color = background_color
		name_bg.color = background_color

@export var panel_color: Color:
	set(value):
		panel_color = value
		
		if not is_inside_tree():
			await ready
		
		borders.self_modulate = panel_color


@export var panel_title: String:
	set(value):
		panel_title = value
		
		if not is_inside_tree():
			await ready
		
		name_label.text = panel_title


@onready var bg: ColorRect = $Background
@onready var borders: NinePatchRect = $Borders
@onready var name_bg: ColorRect = $Borders/NameMargin/ColorRect
@onready var name_label: Label = $Borders/NameMargin/Label

func setup() -> void:
	hide()
	
	#bg.modulate = bg_colour
	#borders.self_modulate = panel_colour
	#name_bg.color = bg_colour
	#name_label.text = panel_name
	
	# Resize the content to be divisible by the screen tile size (8x8).
	await get_tree().process_frame
	
	var panel_tile_width: = ceili(size.x / Constants.TILE_SIZE.x)
	var panel_tile_height: = ceili(size.y / Constants.TILE_SIZE.y)
	size.x = panel_tile_width * Constants.TILE_SIZE.x
	size.y = panel_tile_height * Constants.TILE_SIZE.y
	show()
