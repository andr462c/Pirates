extends RigidBody2D

var speed	
var deathtimer
var direction: Vector2
var sprite: Sprite2D


func init(_position: Vector2, _speed: float, _direction: Vector2, dont_collide_with: Node2D):
	position = _position
	speed =	 _speed	
	direction = _direction
	sprite = $Sprite2D
	add_collision_exception_with(dont_collide_with)

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(direction*speed*mass)
	sprite.rotation = direction.angle()


func _on_body_entered(body):
	# body.apply_impulse(direction*400, global_position)
	# queue_free()
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func _on_killtimer_timeout():
	queue_free()	
