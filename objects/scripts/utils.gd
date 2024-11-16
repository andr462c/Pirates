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
