extends Node2D

@onready var players: Node2D = Utils.find_child(get_tree().root, "Players")
var shoot_direction = Vector2(0, 0)
var bullet_speed_multiplier = 1.0
var weapons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapons = Utils.GetWeapons(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pirates: Array[Node2D] = []
	for c in players.get_children():
		pirates.append(c)
	var nearest_pirate = Utils.find_nearest(global_position, pirates)
	if nearest_pirate == null:
		return
		
	var direction = (nearest_pirate.global_position - global_position).normalized()
	var angle = atan2(direction.x, -direction.y)
	# global_rotation = atan2(direction.x, -direction.y)
	
	shoot_direction = Vector2.from_angle(angle - PI/2)
	for weapon in weapons:
		weapon.update_stats(self)
		weapon.shoot()
