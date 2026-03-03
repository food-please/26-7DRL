class_name Stats extends Resource

signal hp_changed
signal hp_depleted

@export_range(0, 1, 1, "or_greater") var max_hp: = 10
@export_range(0, 1, 1, "or_greater") var hp: = 5:
	set(value):
		value = clampi(value, 0, max_hp)
		if hp != value:
			hp = value
			hp_changed.emit()
			
			if hp <= 0:
				hp_depleted.emit()

@export_range(0, 1.0) var initiative: = 1.0

@export_range(0, 1, 1, "or_greater") var attack: = 4
@export_range(0, 1, 1, "or_greater") var defense: = 2
