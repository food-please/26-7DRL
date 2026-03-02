# Defines a given character type, including graphics, stats, etc.
class_name Character extends Resource

@export var name: String

# GFX
@export_category("GFX")
@export var texture: Texture
@export_color_no_alpha var colour: Color
