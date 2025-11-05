class_name Constants
enum NetNodeVariant {
    SOURCE,
    SINK,
	CONDUIT,
}

class Net:
	var nodes: Array[NetNode]
	var status: String
	var value: float

class NetNode:
	var node: Node
	var variant: NetNodeVariant
