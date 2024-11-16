extends RigidBody2D

class_name PlayerBoat

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
var jumptimer: Timer

var id = 0

@onready
var hit_sound = $HitSound
@onready
var jump_sound = $JumpSound

var death_sound = preload("res://objects/sounds/player_die.tscn")

@onready
var sprite_modulator = $SpriteModulator

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D
	jumptimer = $Jumptimer
	gravity_scale = 0
	weapons = Utils.GetWeapons(self)

func _integrate_forces(state):
	pass
	#target_direction = Input.get_vector("key_left_%d" % id, "key_right_%d" % id, "key_up_%d" % id, "key_down_%d" % id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Update pos
	if not jumping:
		target_direction = Input.get_vector("key_left_%d" % id, "key_right_%d" % id, "key_up_%d" % id, "key_down_%d" % id)
	if target_direction.length() > 0.1:
		direction = target_direction
		set_constant_force(direction*acceleration)
	else:
		set_constant_force(Vector2(0,0))
	
	target_shoot_direction = Input.get_vector("key_shoot_left_%d" % id, "key_shoot_right_%d" % id, "key_shoot_up_%d" % id, "key_shoot_down_%d" % id)
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
	if Input.is_action_just_pressed("ui_accept"):
		preload("res://objects/modifiers/rpg_upgrade.tscn").instantiate().modify_player(self)
	if Input.is_action_pressed("key_jump_%d" % id) and not jumping and jumptimer.is_stopped():
		jump_sound.play()
		jumping = true
		z_speed = 0.1
		set_collision_layer_value(1,false)
		set_collision_mask_value(1,false)
		
	if jumping:
		z += z_speed
		z_speed -= delta*0.5
		if z < 0:
			z = 0
			jumping = false
			set_collision_layer_value(1, true)
			set_collision_mask_value(1, true)
			jumptimer.start(0.3)
		scale = Vector2(1+z*2,1+z*2)

	if should_shoot and not jumping and jumptimer.is_stopped():
		shoot()


func shoot():
	weapons = Utils.GetWeapons(self)
	for weapon in weapons:
		weapon.update_stats(self)
		weapon.shoot()	

func take_damage(damage: float):
	health -= damage
	if !hit_sound.playing:
		hit_sound.play()
	get_node("/root/Main/Healthbars/P%dHealth" % id).value -= max(damage, 0)
	print("health: ", health, ", ", damage)
	sprite_modulator.modulate(sprite)
	if health <= 0:
		get_tree().root.add_child(death_sound.instantiate())
		queue_free()
	
