extends RigidBody2D

var speed	
var deathtimer
var direction: Vector2
var sprite: Sprite2D
var damage
var kill_timer: float
var bullet_pattern: BulletPattern

func init(_position: Vector2, _speed: float, _direction: Vector2, dont_collide_with: Array, _damage: float, _kill_timer: float, _bullet_pattern: BulletPattern):
	position = _position
	speed =	 _speed	
	direction = _direction
	sprite = $Sprite2D
	damage = _damage
	kill_timer = _kill_timer
	Utils.add_collisions_ignore(self, dont_collide_with)
	bullet_pattern = _bullet_pattern

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(direction*speed*mass)
	sprite.rotation = direction.angle()
	$killtimer.wait_time = kill_timer


func _on_body_entered(body):
	print("Hit something ", body)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if bullet_pattern != null:
		bullet_pattern.add_pattern_force(self, delta)

func _on_killtimer_timeout():
	queue_free()	
