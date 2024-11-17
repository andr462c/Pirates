extends Node2D

@onready var enemy_movement = $EnemyMovement
@export var health = 10
@onready var sprite = $Sprite2D
@onready var sprite_modulator = $SpriteModulator
@onready var hit_sound = $WoodHitSound
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#enemy_movement.angular_factor = 0.02
	#enemy_movement.speed = 40_000
	#enemy_movement.points = [Vector2(50, 100), Vector2(550, 100)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass


func take_damage(damage: float):
	health -= damage
	(get_node("/root/Main/Healthbars/EnemyHealth") as TextureProgressBar).value -= max(damage, 0)
	hit_sound.play()
	sprite_modulator.modulate(sprite)
	if health <= 0:
		queue_free()
	
