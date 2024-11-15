extends Node2D

var speed = 256		
var deathtimer
var direction: Vector2
var sprite: Sprite2D


func init(_position: Vector2, _speed_multiplier: float, _direction: Vector2):
	position = _position
	speed *= _speed_multiplier	
	direction = _direction

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D
	sprite.rotation = direction.angle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction*speed*delta
