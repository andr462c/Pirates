extends Node2D

@onready var players: Node2D = Utils.find_child(get_tree().root, "Players")
var shoot_direction = Vector2(0, 0)
var bullet_speed_multiplier = 1.0
var weapons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapons.append($Ak47)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var nearest_pirate: Node2D
	var nearest_dist = 0
	for pirate in players.get_children():
		var dist = (global_position - pirate.global_position).length()
		if nearest_pirate == null or dist < nearest_dist:
			nearest_dist = dist
			nearest_pirate = pirate
	if nearest_pirate == null:
		return
	var direction = (nearest_pirate.global_position - global_position).normalized()
	global_rotation = atan2(direction.x, -direction.y)
	
	shoot_direction = Vector2.from_angle(global_rotation - PI/2)
	for weapon in weapons:
		weapon.update_stats(self)
		weapon.shoot()
