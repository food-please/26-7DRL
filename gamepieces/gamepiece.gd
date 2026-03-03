@tool
@icon("res://gamepieces/icon_gamepiece.png")
class_name Gamepiece extends Node2D

## Emitted whenever the gamepiece is ready to act.
signal turn_started

## Emitted after the gamepiece has taken its turn.
signal turn_ended

signal moved(old_cell: Vector2i)

@export var character: Character:
	set(value):
		if value == character:
			return
		
		character = value
		
		if not is_inside_tree():
			await ready
		
		if character == null:
			sprite.texture = null
			sprite.modulate = Color.WHITE
		
		else:
			sprite.texture = character.texture
			sprite.modulate = character.colour

var actor: Actor

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

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var bg: ColorRect = $Background
@onready var sprite: Sprite2D = $Anchor/Sprite2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if Map.gameboard == null:
		await Map.references_set
	
	bg.show()
	bg.color = Map.gameboard.bg_color
	
	assert(character != null, "Gamepiece %s needs a Character assigned!" % name)
	assert(character.stats != null, "Gamepiece %s needs Stats assigned!" % name)
	
	character = character.duplicate()
	character.stats = character.stats.duplicate()
	character.stats.hp_depleted.connect(_on_hp_depleted)
	
	cell = Map.gameboard.px_to_cell(position)
	position = Map.gameboard.cell_to_px(cell)
	
	actor = Actor.new(character.stats.initiative)
	if Map.gamepieces.register(self, cell) == false:
		queue_free()


func start_turn() -> void:
	print("\n%s starts their turn!" % name)
	turn_started.emit()


func end_turn(charge_consumed: = 1.0) -> void:
	actor.charge = maxf(0.0, actor.charge - charge_consumed)
	turn_ended.emit()


func take_hit(damage_value: int) -> void:
	if character.stats.hp - damage_value <= 0:
		anim.play("die")
	
	else:
		anim.play("hurt")
	
	character.stats.hp -= damage_value


#func move(direction: Directions.Points) -> bool:
	#var offset: Vector2i = Directions.OFFSETS.get(direction)
	#var new_cell: = cell + offset
	#
	#cell = new_cell
	#
	#return true

func _on_hp_depleted() -> void:
	if anim.is_playing():
		await anim.animation_finished
	queue_free()


func _to_string() -> String:
	return "Gamepiece: %s" % name + \
		"\n\t(Charge = %f)" % actor.charge
