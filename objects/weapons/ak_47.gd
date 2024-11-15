extends Node2D
var bullet_scene = preload("res://objects/bullets/normal_bullet.tscn")
var shoot_direction: Vector2 = Vector2(1,0)
var speed_multiplier = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_stats(playerboat):
	shoot_direction = playerboat.shoot_direction
	speed_multiplier = playerboat.bullet_speed_multiplier
	

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.init(global_position, speed_multiplier, shoot_direction)
	get_tree().root.add_child(bullet)
