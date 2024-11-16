extends RigidBody2D

var speed = Vector2(0,0)
var max_speed = 150
@export var acceleration = 50
var direction = 0
var target_direction = Vector2(0,0)
var brake_factor = 2.0
var sprite: Sprite2D
var shoot_direction = Vector2(0, 0)
var target_shoot_direction: Vector2
var bullet_speed_multiplier = 1.0

var weapons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D
	#weapons.append($Ak47)
	weapons.append($Shotgun)

func _integrate_forces(state):
	target_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Update pos
	target_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if target_direction.length() > 0.1:
		direction = target_direction
		set_constant_force(direction*acceleration)
	else:
		set_constant_force(Vector2(0,0))
	
	target_shoot_direction = Input.get_vector("key_shoot_left", "key_shoot_right", "key_shoot_up", "key_shoot_down")
	if target_shoot_direction.length() > 0.1:
		shoot_direction = target_shoot_direction.normalized()


	if linear_velocity.length() > 0.1:  # Avoid rotating if the object is nearly stationary
		var target_angle = atan2(direction.x, -direction.y)
		var current_angle = rotation
		var angle_diff = target_angle - current_angle

		# Normalize angle_diff to the range [-PI, PI]
		angle_diff = wrapf(angle_diff, -PI, PI)
	
		# Apply angular velocity or torque to rotate toward the target angle
		angle_diff = clamp(angle_diff, -PI/12, PI/12)
		angular_velocity = angle_diff / delta
		# speed += acceleration*delta*direction
		# sprite.rotation = direction.angle()
	# speed *= 0.95

	# if speed.length() > max_speed:
	# 	speed = speed.limit_length(max_speed)
	# position += speed

	if Input.is_action_pressed("key_shoot"):
		shoot()


func shoot():
	for weapon in weapons:
		weapon.update_stats(self)
		weapon.shoot()	
