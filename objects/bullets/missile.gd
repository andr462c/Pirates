extends RigidBody2D

var speed	
var deathtimer
var direction: Vector2
var sprite: Sprite2D

var explosion_scene = preload("res://objects/bullets/explosion.tscn")

func init(_position: Vector2, _speed: float, _direction: Vector2, dont_collide_with: Array):
	position = _position
	speed =	 _speed	
	direction = _direction
	sprite = $Sprite2D
	for node in dont_collide_with:
		if node is PhysicsBody2D:
			add_collision_exception_with(node)

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(direction*speed*mass)
	sprite.rotation = direction.angle()


func _on_body_entered(body):
	# body.apply_impulse(direction*400, global_position)
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	get_tree().root.call_deferred("add_child", explosion)
	queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func _on_killtimer_timeout():
	queue_free()	
