extends Node2D

var direction = 0
var shoot_direction = Vector2.UP
@export var spin_speed = 1.0
var weapon
@export var bullet_speed_multiplier = 1.0
@export var start_offset = 0.0

func _ready():
	weapon = get_child(0)
	print("WEAPON ", weapon)
	direction = 2 * PI * start_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction += delta*spin_speed
	shoot_direction = Vector2.from_angle(direction)
	weapon.update_stats(self)
	weapon.shoot()

func _on_containertimer_timeout():
	pass # Replace with function body.
