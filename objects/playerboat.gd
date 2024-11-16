extends RigidBody2D

var speed = Vector2(0,0)
var max_speed = 150
@export var acceleration = 500000
var direction = Vector2(1,0)
var target_direction = Vector2(0,0)
var brake_factor = 2.0
var sprite: Sprite2D
var shoot_direction = Vector2(0, 0)
var target_shoot_direction: Vector2
var bullet_speed_multiplier = 1.0
var jumping = false
var z = 0.0
var z_speed = 0
var colshape: CollisionShape2D
var weapons = []
@export var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D
	colshape = $CollisionShape2D
	gravity_scale = 0
	weapons.append($Ak47)
	#weapons.append($Shotgun)
	#	weapons.append($Rpg)

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
	var should_shoot = target_shoot_direction.length() > 0


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
	if Input.is_action_just_pressed("key_jump") and not jumping:
		jumping = true
		z_speed = 0.1
		colshape.disabled = true
		
	if jumping:
		z += z_speed
		z_speed -= delta*0.5
		if z < 0:
			z = 0
			jumping = false
			colshape.disabled = false
		sprite.scale = Vector2(1+z,1+z)

	if should_shoot:
		shoot()

#
func shoot():
	for weapon in weapons:
		weapon.update_stats(self)
		weapon.shoot()	

func take_damage(damage: float):
	health -= damage
	print("health: ", health)
	if health <= 0:
		queue_free()
	
