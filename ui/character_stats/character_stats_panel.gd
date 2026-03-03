@tool
class_name CharacterStatsPanel extends BasePanel

var gp: Gamepiece:
	set(value):
		if not is_inside_tree():
			await ready
		
		if gp != value:
			if gp != null:
				gp.character.stats.hp_changed.disconnect(_on_hp_changed)
			
			gp = value
			if gp != null:
				var stats: = gp.character.stats
				panel_title = gp.character.name
				stats.hp_changed.connect(_on_hp_changed)
				
				attack_label.text = str(stats.attack)
				defense_label.text = str(stats.defense)
				
				await get_tree().process_frame
				await get_tree().process_frame
				await get_tree().process_frame
				_on_hp_changed()

@onready var hp_bar: StatsBar = $%HPBar
@onready var attack_label: Label = $%AttackValue
@onready var defense_label: Label = $%DefenseValue

func _on_hp_changed() -> void:
	if gp == null:
		return
	
	var stats: = gp.character.stats
	hp_bar.set_value("HP", stats.max_hp, stats.hp)
