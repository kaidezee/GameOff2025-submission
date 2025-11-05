extends Node2D

@export var input_value := 0.0
@export var t := 0.0

var input_buffer := PackedFloat64Array()

func _physics_process(_delta: float) -> void:
	input_buffer.remove_at(0)
	for i in range(0, 63):
		input_buffer[i] = input_buffer[i + 1]
	input_buffer[64] = input_value

	print(input_value)
