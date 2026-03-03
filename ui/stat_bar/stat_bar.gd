@tool
class_name StatsBar extends MarginContainer

@export var bg_texture: Texture:
	set(value):
		bg_texture = value
		
		if not is_inside_tree():
			await ready
		
		for child: TextureRect in bar_bg.get_children():
			child.texture = bg_texture

@export_range(0, 1, 1, "or_greater") var num_increments: int:
	set(value):
		num_increments = value
		
		if not is_inside_tree():
			await ready
		
		if num_increments > bar_bg.get_child_count():
			while bar_bg.get_child_count() < num_increments:
				var new_texture_rect: = TextureRect.new()
				new_texture_rect.name = "BackgroundTexture"
				new_texture_rect.texture = bg_texture
				bar_bg.add_child(new_texture_rect, true)
				new_texture_rect.owner = self
				await get_tree().process_frame
		
		elif num_increments < bar_bg.get_child_count():
			while bar_bg.get_child_count() > num_increments:
				print("Freeing!")
				bar_bg.get_child(0).queue_free()
				await get_tree().process_frame
				print(size)
		
		progress.step = 100.0/bar_bg.get_child_count()

@onready var bar_bg: Control = $Background
@onready var progress: TextureProgressBar = $Value
@onready var label: Label = $Offset/MarginContainer/Label


func set_value(stat_name: String, stat_max: int, stat_value: int) -> void:
	label.text = "%s %d/%d" % [stat_name, stat_value, stat_max]
	progress.value = float(stat_value)/float(stat_max)*100.0
