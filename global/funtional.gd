class_name F
extends Object

static func child_at(node: Node, index: int):
	if index >= node.get_child_count():
		return null
	return node.get_child(index)

static func front(array: Array):
	if array.size() == 0:
		return null
	return array.front()
