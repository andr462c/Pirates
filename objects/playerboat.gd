extends Node2D

var speed = Vector2(0,0)
var max_speed = 150
var acceleration = 50
var direction = 0
var target_direction = Vector2(0,0)
var brake_factor = 2.0
var sprite: Sprite2D
var shoot_direction: Vector2
var bullet_speed_multiplier = 1.0

var weapons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Ready")
	sprite = $Sprite2D
	weapons.append($Ak47)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update pos
	target_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	print(target_direction)
	direction = target_direction
	if target_direction.length() > 0.1:
		shoot_direction = target_direction.normalized()	
		speed += acceleration*delta*direction
		sprite.rotation = direction.angle()
	speed *= 0.95

	if speed.length() > max_speed:
		speed = speed.limit_length(max_speed)
	position += speed

	if Input.is_action_pressed("key_shoot"):
		shoot()


func shoot():
	for weapon in weapons:
		weapon.update_stats(self)
		weapon.shoot()	
