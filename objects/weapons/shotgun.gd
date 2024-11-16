extends Node2D
var bullet_scene = preload("res://objects/bullets/normal_bullet.tscn")
var shoot_direction: Vector2 = Vector2(1,0)
@export var speed = 5000
@export
var number_of_bullets = 5
@export_range(0.1, PI)
var fan_spread = PI / 2
var reload_timer: Timer
var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	reload_timer = $Reload
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_stats(playerboat):
	shoot_direction = playerboat.shoot_direction
	speed = speed*playerboat.bullet_speed_multiplier
	

func shoot():
	if not can_shoot:
		return
	can_shoot=false
	
	var offset = -(fan_spread / 2)
	var delta = fan_spread / number_of_bullets
	for i in number_of_bullets:
		var real_direction = shoot_direction.rotated(offset)
		var bullet = bullet_scene.instantiate()
		bullet.init(global_position, speed, real_direction, get_parent())
		get_tree().root.add_child(bullet)
		offset += delta
	
	reload_timer.start()	

func _on_reload_timeout():
	can_shoot = true
