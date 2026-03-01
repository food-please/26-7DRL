## A utility class converting between Godot angles (+'ve x axis is 0 rads) and cardinal points.
class_name Directions
extends RefCounted

## Abbreviations for 8 cardinal points (i.e. NW = Northwest, or Vector2[-1, -1]).
enum Points { NW, N, NE, E, SE, S, SW, W }

const OFFSETS: = {
	Points.NW: Vector2i(-1, -1),
	Points.N: Vector2i.UP,
	Points.NE: Vector2i(1, -1),
	Points.E: Vector2i.RIGHT,
	Points.SE: Vector2i(1, 1),
	Points.S: Vector2i.DOWN,
	Points.SW: Vector2i(-1, 1),
	Points.W: Vector2i.LEFT
}


## Convert an angle, such as from [method Vector2.angle], to a [constant Points].
static func angle_to_direction(angle: float) -> Points:
	if angle <= -PI/4 and angle > -3*PI/4:
		return Points.N
	elif angle <= PI/4 and angle > -PI/4:
		return Points.E
	elif angle <= 3*PI/4 and angle > PI/4:
		return Points.S
	
	return Points.W
