extends Node2D
var bullet_scene = preload("res://objects/bullets/missile.tscn")
var shoot_direction: Vector2 = Vector2(1,0)
@export var speed = 4000
var reload_timer: Timer
var can_shoot = true
@export var damage = 20
@export var kill_time = 0.5
@export var shooting_timeout = 1
@export var pattern = preload("res://objects/bullets/bullet_patterns/pattern.tscn")

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
	var bullet = bullet_scene.instantiate()
	bullet.init(global_position, speed, shoot_direction, Utils.get_parents(self), damage, kill_time, pattern.instantiate())
	get_tree().root.add_child(bullet)
	reload_timer.start(shooting_timeout)	

func _on_reload_timeout():
	can_shoot = true
