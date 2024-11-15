extends Node2D

var speed = Vector2(0,0)
var max_speed = 150
var acceleration = 50
var direction = 0
var target_direction = Vector2(0,0)
var brake_factor = 2.0
var sprite: Sprite2D

var bullet_scene = preload("res://objects/normal_bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Ready")
	sprite = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update pos
	target_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = target_direction
	if direction.length() > 0.1:
		speed += acceleration*delta*direction
		sprite.rotation = direction.angle()
	speed *= 0.95

	if speed.length() > max_speed:
		speed = speed.limit_length(max_speed)
	position += speed

	if Input.is_action_pressed("key_shoot"):
		shoot()			


func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.init(1, target_direction)
	get_tree().root.add_child(bullet)

