# Created by a [Gamepiece], tracks when it's able to take a turn.
class_name Actor extends RefCounted

signal charged

var is_active: = true

var charge_rate: = 1.0

# Fluctuates between 0 and 1. When it reaches 1 it has fully charged.
var charge: = 0.0


func _init(rate: float) -> void:
	charge_rate = rate


func reset() -> void:
	charge = 0.0


func tick(num_increments: = 1) -> void:
	if not is_active:
		return
	
	if charge < 1.0:
		for _i in range(num_increments):
			charge += charge_rate
	
	if charge >= 1.0:
		charged.emit()
