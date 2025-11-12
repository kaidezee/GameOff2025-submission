class_name Constants
enum NetNodeVariant {
    SOURCE,
    SINK,
	CONDUIT,
}

enum NetStatus {
	OK,
	ERROR,
}

class Net:
	var nodes: Array[NetNode]
	var source: NetNode
	var status: NetStatus
	var value: float

class NetNode:
	var node: Node
	var variant: NetNodeVariant
