extends Node2D

func build() -> void:
	var newNode = load("res://scenes/source.tscn").instantiate()
	newNode.visible = false

	newNode.position = position + Vector2(sin(rotation + PI/2), -cos(rotation + PI/2)) * 50.0

	var netNodes: Array[Constants.NetNode] = [Constants.NetNode.new()]
	netNodes[0].node = newNode
	netNodes[0].variant = Constants.NetNodeVariant.SOURCE

	$"/root/Game/Logic".add_network_nodes(netNodes)

func get_value(elapsed: float) -> float:
	return sin(elapsed)
