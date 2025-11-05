extends Node2D

@export var GRID_RESOLUTION := 25

@onready var wireScene: PackedScene = load("res://scenes/wire.tscn")

var vertices: PackedVector2Array

var is_middle_mouse_button_pressed := false
var buildableInstance: Node # As long as this is null, logic will ignore it.

var wireHologramDst := Vector2(1.0, 1.0)
var wireHologramInstance: Node
var isRoutingWire := false
var wireSrc := Vector2(1.0, 1.0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("middleMouseButton"):
		is_middle_mouse_button_pressed = true
	if event.is_action_released("middleMouseButton"):
		is_middle_mouse_button_pressed = false
	if event is InputEventMouseMotion and is_middle_mouse_button_pressed:
		$Camera.transform.origin.y -= event.relative.y * 1.0
		$Camera.transform.origin.x -= event.relative.x * 1.0
	
	if event.is_action_pressed("leftMouseButton") and buildableInstance != null:
		buildableInstance.build()
		buildableInstance = null # "Leave it alone" by nullifying this reference to it.
	
	if event.is_action_pressed("rightMouseButton") and isRoutingWire:
		wireSrc = Vector2(1.0, 1.0)
		isRoutingWire = false
		if wireHologramInstance != null:
			wireHologramInstance.queue_free()

	elif event.is_action_pressed("leftMouseButton") and isRoutingWire and wireSrc == Vector2(1.0, 1.0):
		wireSrc = nearest_grid_vertex(get_local_mouse_position())

	elif event.is_action_released("leftMouseButton") and isRoutingWire and wireSrc != Vector2(1.0, 1.0):
		var wireDst = nearest_grid_vertex(get_local_mouse_position())

		var wireInstance: Node = wireScene.instantiate()
		wireInstance.src = wireSrc
		wireInstance.dst = wireDst
		wireInstance.is_final = true
		add_child(wireInstance)

		wireSrc = Vector2(1.0, 1.0)
		isRoutingWire = false
		
		if wireHologramInstance != null:
			wireHologramInstance.queue_free()

func nearest_grid_vertex(pos: Vector2) -> Vector2:
	var a4 = Vector2(floor(pos.x/GRID_RESOLUTION)*GRID_RESOLUTION, floor(pos.y/GRID_RESOLUTION)*GRID_RESOLUTION)
	var a2 = Vector2(ceil(pos.x/GRID_RESOLUTION)*GRID_RESOLUTION, ceil(pos.y/GRID_RESOLUTION)*GRID_RESOLUTION)
	var a3 = Vector2(ceil(pos.x/GRID_RESOLUTION)*GRID_RESOLUTION, floor(pos.y/GRID_RESOLUTION)*GRID_RESOLUTION)
	var a1 = Vector2(floor(pos.x/GRID_RESOLUTION)*GRID_RESOLUTION, ceil(pos.y/GRID_RESOLUTION)*GRID_RESOLUTION)

	var v1 = sqrt(
		(a1.x - pos.x)**2.0 +
		(a1.y - pos.y)**2.0
	)
	var v2 = sqrt(
		(a2.x - pos.x)**2.0 +
		(a2.y - pos.y)**2.0
	)
	var v3 = sqrt(
		(a3.x - pos.x)**2.0 +
		(a3.y - pos.y)**2.0
	)
	var v4 = sqrt(
		(a4.x - pos.x)**2.0 +
		(a4.y - pos.y)**2.0
	)

	match [v1, v2, v3, v4].min():
		v1:
			return a1
		v2:
			return a2
		v3:
			return a3
		v4:
			return a4
		_:
			return Vector2.ZERO

func _physics_process(_delta: float) -> void:
	var mouseNearestGridVertex = nearest_grid_vertex(get_local_mouse_position())

	if buildableInstance != null:
		buildableInstance.position = mouseNearestGridVertex

	if isRoutingWire and wireSrc != Vector2(1.0, 1.0) and wireHologramDst != mouseNearestGridVertex:
		wireHologramDst = mouseNearestGridVertex

		if wireHologramInstance != null:
			wireHologramInstance.queue_free()

			wireHologramInstance = wireScene.instantiate()
			wireHologramInstance.src = wireSrc
			wireHologramInstance.dst = mouseNearestGridVertex
			add_child(wireHologramInstance)
		else:
			wireHologramInstance = wireScene.instantiate()
			wireHologramInstance.src = wireSrc
			wireHologramInstance.dst = mouseNearestGridVertex
			add_child(wireHologramInstance)

func _on_source_button_pressed() -> void:
	var scene: PackedScene = load("res://scenes/source.tscn")
	buildableInstance = scene.instantiate()
	add_child(buildableInstance)

func _on_wire_button_pressed() -> void:
	isRoutingWire = true
