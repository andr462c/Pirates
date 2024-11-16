extends Node2D

@onready var players: Node2D = get_node('/root/FrankTestScene/Players')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var nearest_pirate: Node2D
	var nearest_dist = 0
	for pirate in players.get_children():
		var dist = (global_position - pirate.global_position).length()
		if nearest_pirate == null or dist < nearest_dist:
			nearest_dist = dist
			nearest_pirate = pirate
	print(nearest_pirate)
	var direction = (nearest_pirate.global_position - global_position).normalized()
	rotation = atan2(direction.x, -direction.y)
