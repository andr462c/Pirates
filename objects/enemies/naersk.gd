extends RigidBody2D

@onready
var sprite: Sprite2D = $Sprite2D

@onready
var sprite_modulator = $SpriteModulator

@export
var health = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage: float):
	health -= damage
	sprite_modulator.modulate(sprite)
	if health <= 0:
		queue_free()
