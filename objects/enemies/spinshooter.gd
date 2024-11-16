extends Node2D

var direction = 0
var shoot_direction = Vector2.UP
@export var spin_speed = 1
var weapon
@export var bullet_speed_multiplier = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	weapon = get_child(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction += delta*spin_speed
	shoot_direction = Vector2.from_angle(direction)
	weapon.update_stats(self)
	weapon.shoot()
	
	
