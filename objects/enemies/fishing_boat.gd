extends Node2D

@onready var enemy_movement = $EnemyMovement
@export var health = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_movement.angular_factor = 0.02
	enemy_movement.speed = 40_000
	enemy_movement.points = [Vector2(50, 100), Vector2(550, 100)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	enemy_movement.apply_movement(delta, self)


func take_damage(damage: float):
	print("Enemy taking damage")
	health -= damage
	if health <= 0:
		queue_free()
	
