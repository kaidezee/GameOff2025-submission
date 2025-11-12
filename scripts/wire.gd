extends Node2D

@export var src: Vector2
@export var dst: Vector2
@export var is_final := false

var THICKNESS_MOD = 0.3
var OK_COLOR = Color.html("#ff9955ff")
var ERR_COLOR = Color.html("#de3232ff")

var idNode: Constants.NetNode
var color := Color.html("#ff9955ff")
var vertices: PackedVector2Array

func _ready() -> void:
	vertices = build_grid_path(src, dst)
	queue_redraw()

	if is_final:
		var srcNode: Node2D = Node2D.new()
		srcNode.position = src
		get_parent().add_child(srcNode)

		var srcNetNode = Constants.NetNode.new()
		srcNetNode.node = srcNode
		srcNetNode.variant = Constants.NetNodeVariant.CONDUIT

		var dstNode: Node2D = Node2D.new()
		dstNode.position = dst
		get_parent().add_child(dstNode)

		var dstNetNode = Constants.NetNode.new()
		dstNetNode.node = dstNode
		dstNetNode.variant = Constants.NetNodeVariant.CONDUIT

		var netNodes: Array[Constants.NetNode] = [srcNetNode, dstNetNode]

		idNode = srcNetNode
		$"/root/Game/Logic".add_network_nodes(netNodes)

func _draw() -> void:
	for i in range(0, vertices.size() - 1):
		draw_line(vertices[i], vertices[i + 1], color, THICKNESS_MOD*25.0)
		draw_circle(vertices[i], 25*THICKNESS_MOD*0.5, color)
	
	draw_circle(vertices[vertices.size() - 1], 25*THICKNESS_MOD, color)
	draw_circle(vertices[0], 25*THICKNESS_MOD, color)

func find_grid_step(source: Vector2, destination: Vector2) -> Vector2:
	var initial_path = sqrt(
		(destination.x - source.x)**2.0 +
		(destination.y - source.y)**2.0
	)	

	var biggest_path_reduction := 0.0
	var biggest_path_reduction_index := 0

	var possible_dsts := PackedVector2Array([
		source + Vector2( 25.0,   0.0),
		source + Vector2( 25.0, -25.0),
		source + Vector2(  0.0, -25.0),
		source + Vector2(-25.0, -25.0),
		source + Vector2(-25.0,   0.0),
		source + Vector2(-25.0,  25.0),
		source + Vector2(  0.0,  25.0),
		source + Vector2( 25.0,  25.0),
	])

	for pos in $"/root/Game/Logic".takenPositions:
		for possible_dst in possible_dsts:
			if possible_dst == pos:
				possible_dsts.erase(possible_dst)

	for i in range(0, possible_dsts.size()):	
		var path_reduction = initial_path - sqrt(
			(destination.x - possible_dsts[i].x)**2.0 +
			(destination.y - possible_dsts[i].y)**2.0
		)
		if path_reduction > biggest_path_reduction:
			biggest_path_reduction = path_reduction
			biggest_path_reduction_index = i

	return possible_dsts[biggest_path_reduction_index]

func build_grid_path(source: Vector2, destination: Vector2) -> PackedVector2Array:
	var posList := PackedVector2Array()
	posList.append(source)

	var current_pos := source
	while current_pos != destination:
		current_pos = find_grid_step(current_pos, destination);
		posList.append(current_pos)
	
	return posList

func _physics_process(_delta: float) -> void:
	if is_final:
		var net = $"/root/Game/Logic".get_network_from_node(idNode)

		if net.status == Constants.NetStatus.ERROR and color != ERR_COLOR:
			color = ERR_COLOR
			queue_redraw()
		if net.status == Constants.NetStatus.OK and color != OK_COLOR:
			color = ERR_COLOR
			queue_redraw()
