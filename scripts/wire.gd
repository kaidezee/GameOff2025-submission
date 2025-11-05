extends Node2D

@export var src: Vector2
@export var dst: Vector2
@export var is_final := false

var THICKNESS_MOD = 0.3

var vertices: PackedVector2Array

func _ready() -> void:
	vertices = build_grid_path(src, dst)
	queue_redraw()

	var nets: Array[Constants.Net] = []
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

		for net in $"/root/Game/Logic".networks:
			for netNode in net.nodes:
				if netNode.node.position == src or netNode.node.position == dst:
					nets.append(net)

		if nets.is_empty():
			var newNet = Constants.Net.new()
			newNet.nodes.append(srcNetNode)
			newNet.nodes.append(dstNetNode)
			$"/root/Game/Logic".networks.append(newNet)
		elif nets.size() == 1:
			nets[0].nodes.append_array([srcNetNode, dstNetNode])

			var doesDstExist = false
			var doesSrcExist = false
			for netNode in nets[0].nodes:
				if netNode.node.position == srcNode.position:
					doesSrcExist = true
				if netNode.node.position == dstNode.position:
					doesDstExist = true

			if not doesSrcExist:
				nets[0].nodes.append(srcNetNode)
			if not doesDstExist:
				nets[0].nodes.append(dstNetNode)
				
		elif nets.size() > 1:
			var newNetNodes: Array[Constants.NetNode] = []
			newNetNodes.append_array([srcNetNode, dstNetNode])

			for net in nets:
				newNetNodes.append_array(net.nodes)
				
				$"/root/Game/Logic".networks.erase(net)

			var newNet = Constants.Net.new()
			newNet.nodes.append_array(newNetNodes)
			$"/root/Game/Logic".networks.append(newNet)	

func _draw() -> void:
	for i in range(0, vertices.size() - 1):
		draw_line(vertices[i], vertices[i + 1], Color.html("#ff9955ff"), THICKNESS_MOD*25.0)
		draw_circle(vertices[i], 25*THICKNESS_MOD*0.5, Color.html("#ff9955ff"))
	
	draw_circle(vertices[vertices.size() - 1], 25*THICKNESS_MOD, Color.html("#ff9955ff"))
	draw_circle(vertices[0], 25*THICKNESS_MOD, Color.html("#ff9955ff"))

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

	for i in range(0, 8):	
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
