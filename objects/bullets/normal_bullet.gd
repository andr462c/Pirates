extends RigidBody2D

var speed	
var deathtimer
var direction: Vector2
var sprite: Sprite2D
var damage


func init(_position: Vector2, _speed: float, _direction: Vector2, dont_collide_with: Array, _damage: float):
	position = _position
	speed =	 _speed	
	direction = _direction
	sprite = $Sprite2D
	damage = _damage
	for node in dont_collide_with:
		if node is PhysicsBody2D:
			add_collision_exception_with(node)

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(direction*speed*mass)
	sprite.rotation = direction.angle()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func _on_killtimer_timeout():
	queue_free()	
