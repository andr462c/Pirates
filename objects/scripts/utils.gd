extends Object

class_name Utils

static func GetWeapons(node: Node2D) -> Array[Node]:
	var weapons = node.get_node("Weapons")
	if weapons == null:
		return []
	return weapons.get_children()

static func add_collisions_ignore(node: PhysicsBody2D, nodes: Array):
	for n in nodes:
		if n is PhysicsBody2D:
			node.add_collision_exception_with(n)

static func get_parents(node: Node) -> Array:
	var res = []
	var cur = node
	while true:
		var p = cur.get_parent()
		if p == null:
			break
		res.append(p)
		cur = p
	return res


static func find_child(node: Node, name: String) -> Node:
	if node.name == name:
		return node
	for c in node.get_children():
		var res = find_child(c, name)
		if res != null:
			return res
	return null


static func bounding_box(nodes: Array[Node2D]) -> Array[Vector2]:
	var top_left = Vector2(1_000_000_000, 1_000_000_000)
	var bottom_right = Vector2(-1_000_000_000, -1_000_000_000)
	for n in nodes:
		var p = n.global_position
		top_left.x = min(top_left.x, p.x)
		bottom_right.x = max(bottom_right.x, p.x)
		top_left.y = min(top_left.y, p.y)
		bottom_right.y = max(bottom_right.y, p.y)
	return [top_left, bottom_right]
