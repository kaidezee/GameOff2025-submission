extends Node2D

func build() -> void:
	var node := Node2D.new()
	node.position = position + Vector2(sin(rotation + PI/2), -cos(rotation + PI/2)) * 50.0

	var netNode := Constants.NetNode.new()
	netNode.node = node
	netNode.variant = Constants.NetNodeVariant.SOURCE

	var newNet = Constants.Net.new()
	newNet.nodes.append(netNode)

	$"/root/Game/Logic".networks.append(newNet)
