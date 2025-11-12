extends Node2D

var takenPositions: Array[Vector2] = []
var networks: Array[Constants.Net] = []
var elapsed := 0.0

func get_network_from_node(netNode: Constants.NetNode) -> Constants.Net:
	for net in networks:
		for node in net.nodes:
			if node.node.position == netNode.node.position:
				return net
	return Constants.Net.new()

func add_network_nodes(netNodes: Array[Constants.NetNode]) -> void:
	var nets: Array[Constants.Net] = []

	var newSource: Constants.NetNode
	for node in netNodes:
		if node.variant == Constants.NetNodeVariant.SOURCE:
			newSource = node
			break

	for net in networks:
		if !nets.has(net):	
			var netsIntersect = false
			for existingNetNode in net.nodes:
				for i in range(0, netNodes.size()):
					if existingNetNode.node.position == netNodes[i].node.position:
						netsIntersect = true
			if netsIntersect:
				nets.append(net)

	if nets.is_empty():
		var newNet = Constants.Net.new()
		newNet.nodes.append_array(netNodes)

		if newSource != null:
			newNet.source = newSource
		newNet.status = Constants.NetStatus.OK
		networks.append(newNet)

	elif nets.size() == 1:
		var netNodeExists: Array[bool] = []
		netNodeExists.resize(netNodes.size())
		netNodeExists.fill(false)

		for existingNetNode in nets[0].nodes:
			for i in range(0, netNodes.size()):
				if existingNetNode.node.position == netNodes[i].node.position and existingNetNode.variant == netNodes[i].variant:
					netNodeExists[i] = true

		if newSource != null:
			if nets[0].source != null:
				nets[0].status = Constants.NetStatus.ERROR
			else:
				nets[0].source = newSource

		for i in range(0, netNodes.size()):
			if !netNodeExists[i]:
				nets[0].nodes.append(netNodes[i])

		print(nets[0].source.node)

	elif nets.size() > 1:
		var newNet = Constants.Net.new()
		var newNetNodes: Array[Constants.NetNode] = []

		var sourcesCount := 0
		var netNodeExists: Array[bool]
		netNodeExists.resize(netNodes.size())
		netNodeExists.fill(false)

		for net in nets:
			for existingNetNode in net.nodes:
				for i in range(0, netNodes.size()):
					if existingNetNode.node.position == netNodes[i].node.position and existingNetNode.variant == netNodes[i].variant:
						netNodeExists[i] = true

				if existingNetNode.variant == Constants.NetNodeVariant.SOURCE:
					sourcesCount += 1
					print(existingNetNode.node)

			newNetNodes.append_array(net.nodes)
			networks.erase(net)

		for i in range(0, netNodes.size()):
			if !netNodeExists[i]:
				newNetNodes.append(netNodes[i])

		newNet.nodes.append_array(newNetNodes)
		newNet.status = Constants.NetStatus.OK

		if sourcesCount > 1:
			newNet.status = Constants.NetStatus.ERROR

		if newSource != null:
			if sourcesCount == 1:
				newNet.status = Constants.NetStatus.ERROR
			if sourcesCount == 0:
				newNet.source = newSource

		networks.append(newNet)
		print(sourcesCount)

func _physics_process(delta: float) -> void:
	elapsed += delta

	#for net in networks:
		#print(net.status == Constants.NetStatus.OK)
