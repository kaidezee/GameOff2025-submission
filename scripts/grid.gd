extends Node2D

@export var GRID_COLOR := Color(0.55, 0.55, 0.55)
@export var THICK_LINE_THICKNESS := 2.0
@export var THIN_LINE_THICKNESS := 1.0
@export var GRID_SIZE := Vector2.ZERO

func _draw() -> void:
	for i in range(0, floor(GRID_SIZE.x*2)):
		if i % 100 == 0:
			draw_line(Vector2(i - GRID_SIZE.x, GRID_SIZE.y), Vector2(i - GRID_SIZE.x, -GRID_SIZE.y), GRID_COLOR, THICK_LINE_THICKNESS)
		elif i % 50 == 0:
			draw_line(Vector2(i - GRID_SIZE.x, GRID_SIZE.y), Vector2(i - GRID_SIZE.x, -GRID_SIZE.y), GRID_COLOR, THIN_LINE_THICKNESS)
	
	for i in range(0, floor(GRID_SIZE.y*2)):
		if i % 100 == 0:
			draw_line(Vector2(GRID_SIZE.x, i - GRID_SIZE.y), Vector2(-GRID_SIZE.x, i - GRID_SIZE.y), GRID_COLOR, THICK_LINE_THICKNESS)
		elif i % 50 == 0:
			draw_line(Vector2(GRID_SIZE.x, i - GRID_SIZE.y), Vector2(-GRID_SIZE.x, i - GRID_SIZE.y), GRID_COLOR, THIN_LINE_THICKNESS)
